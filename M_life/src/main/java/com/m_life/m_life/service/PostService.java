package com.m_life.m_life.service;

import com.m_life.m_life.domain.Post;
import com.m_life.m_life.domain.PostCategory;
import com.m_life.m_life.domain.PostImage;
import com.m_life.m_life.domain.UserAccount;
import com.m_life.m_life.dto.request.PostRequest;
import com.m_life.m_life.dto.response.PostResponse;
import com.m_life.m_life.repository.PostCategoryRepository;
import com.m_life.m_life.repository.PostImageRepository;
import com.m_life.m_life.repository.PostRepository;
import com.m_life.m_life.repository.UserAccountRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ZSetOperations;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

@Slf4j
@RequiredArgsConstructor
@Service
public class PostService {
    private final PostRepository postRepository;
    private final PostCategoryRepository postCategoryRepository;
    private final UserAccountRepository userAccountRepository;
    private final PostImageRepository postImageRepository;
    private final S3Service s3Service;
    private final RedisTemplate<String, Object> myredisTemplate;
    private final PostRedisTemplateService postRedisTemplateService;
    private static final Logger logger = LoggerFactory.getLogger(PostService.class);
    private static final String POPULAR_POSTS_KEY = "popular_posts";

    public ResponseEntity<String> save(PostRequest postRequest, UserAccount userAccount, Long categoryId, List<MultipartFile> files) {

        PostCategory postCategory = postCategoryRepository.findById(categoryId)
                .orElseThrow(() -> new IllegalArgumentException("Invalid Category ID"));

        Post post = Post.of(postRequest.title(), postRequest.content(), postCategory);
        post.setUserAccount(userAccount);

        postRepository.save(post);
        if (files != null && !files.isEmpty()) { // 이미지가 있는 경우 이미지도 같이 저장
            uploadImages(post, files);
            postRepository.save(post);
        }

        return ResponseEntity.ok("게시글 작성이 완료되었습니다.");
    }

    @Transactional
    public ResponseEntity<String> update(PostRequest postRequest, Long id, Long categoryId, UserAccount userAccount, List<MultipartFile> files) {
        try {
            // 디버깅용 프린트문 추가

            Post post = postRepository.findById(id)
                    .orElseThrow(() -> new IllegalArgumentException("Invalid post ID"));

            if (!post.getUserAccount().equals(userAccount)) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body("수정 권한이 없습니다.");
            }

            if (postRequest.title() != null) {
                post.setTitle(postRequest.title());
                System.out.println("Title updated to: " + postRequest.title());
            }

            if (postRequest.content() != null) {
                post.setContent(postRequest.content());
                System.out.println("Content updated to: " + postRequest.content());
            }

            PostCategory postCategory = postCategoryRepository.findById(categoryId)
                    .orElseThrow(() -> new IllegalArgumentException("Invalid Category ID"));
            post.setCategory(postCategory);
            System.out.println("Category updated to: " + postCategory.getBoardName());

            // 새로운 이미지 업로드
            List<String> newImageUrls = (files != null && !files.isEmpty()) ?
                    s3Service.uploadPostImages(files, post.getId()) :
                    List.of();
            System.out.println("New image URLs: " + newImageUrls);

            // 기존 URL 유지 및 새 URL 추가
            Set<String> currentImageUrls = new HashSet<>(postRequest.postImageUrls());
            currentImageUrls.addAll(newImageUrls);
            System.out.println("Current image URLs: " + currentImageUrls);

            // 기존 이미지 삭제 로직 - 새로운 URL에 포함되지 않은 기존 이미지 필터링
            List<PostImage> imagesToDelete = post.getImages().stream()
                    .filter(image -> !currentImageUrls.contains(image.getS3Url()))
                    .collect(Collectors.toList());
            System.out.println("Images to delete: " + imagesToDelete);

            for (PostImage image : imagesToDelete) {
                s3Service.deleteImage(image.getS3Url());
            }

            postImageRepository.deleteAll(imagesToDelete);
            post.getImages().removeAll(imagesToDelete);
            System.out.println("Deleted images successfully");

            // 새 이미지를 포스트에 추가
            List<PostImage> uploadedImages = newImageUrls.stream()
                    .map(url -> new PostImage("generated-filename", url, post)) // 파일명을 관리하는 로직이 필요할 수 있음
                    .toList();

            post.getImages().addAll(uploadedImages);
            postRepository.save(post);
            System.out.println("Added new images successfully");

            return ResponseEntity.ok("게시글 수정이 완료되었습니다.");
        } catch (Exception e) {
            e.printStackTrace(); // 디버깅을 위한 스택 트레이스 출력
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("게시글 수정 중 오류가 발생했습니다.");
        }
    }

    private void uploadImages(Post post, List<MultipartFile> files) {
        List<String> s3Urls = s3Service.uploadPostImages(files, post.getId());

        List<PostImage> postImages = IntStream.range(0, s3Urls.size())
                .mapToObj(i -> PostImage.of(files.get(i).getOriginalFilename(), s3Urls.get(i), post))
                .toList();

        post.getImages().addAll(postImages);
    }


    @Transactional
    public ResponseEntity<String> delete(Long id, UserAccount userAccount) {
        boolean isPost = postRepository.existsById(id);
        if (isPost) {
            Post post = postRepository.getReferenceById(id);
            if (!post.getUserAccount().equals(userAccount)) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body("삭제 권한이 없습니다.");
            }

            // S3에 저장된 이미지 삭제
            if (!post.getImages().isEmpty()) {
                for (PostImage image : post.getImages()) {
                    s3Service.deleteImage(image.getS3Url());
                }
                postImageRepository.deleteAll(post.getImages());
            }

            postRepository.deleteById(id);
            postRedisTemplateService.delete(id.toString());
            return ResponseEntity.ok("게시글을 성공적으로 삭제했습니다.");
        } else {
            log.warn("게시글 정보를 찾지 못했습니다.");
            return ResponseEntity.badRequest().body("존재하지 않은 게시글입니다.");
        }
    }

    @Transactional(readOnly = true)
    public List<PostResponse> getAllposts() {
        return postRepository.findAllByOrderByCreateDateDesc().stream()
                .map(post -> PostResponse.from(post, userAccountRepository))
                .collect(Collectors.toList());
    }

    public PostResponse getMypost(Long id) {
        boolean isPost = postRepository.existsById(id);
        if (isPost) {
            Post post = postRepository.findById(id).orElseThrow();
            return PostResponse.from(post, userAccountRepository);
        } else {
            return null;
        }
    }

    public List<PostResponse> getPostsByCategory(Long categoryId) {
            return postRepository.findByCategoryId(categoryId).stream().map(post -> PostResponse.from(post, userAccountRepository))
                    .collect(Collectors.toList());

    }

    public List<PostResponse> getPopularPostsFromAllCategories(long limit) {
        // 1. ZSet을 이용해 게시글 ID 100개 가져오기
        log.info("ZSet에서 상위 {}개의 게시글 ID를 가져옵니다.", limit);
        Set<ZSetOperations.TypedTuple<Object>> topPostIdsWithScores = myredisTemplate.opsForZSet().reverseRangeWithScores(POPULAR_POSTS_KEY, 0, limit - 1);

        // ZSet이 비어 있는 경우, 모든 게시글을 조회하여 ZSet에 추가
        if (topPostIdsWithScores == null || topPostIdsWithScores.isEmpty()) {
            log.info("ZSet이 비어 있습니다. 모든 게시글을 조회하여 ZSet에 추가합니다.");
            initializeZSetWithAllPosts();
            topPostIdsWithScores = myredisTemplate.opsForZSet().reverseRangeWithScores(POPULAR_POSTS_KEY, 0, limit - 1);
        }

        // List로 받아야 순서가 유지된다.
        List<Long> topPostIds = topPostIdsWithScores.stream()
                .map(typedTuple -> Long.valueOf(typedTuple.getValue().toString()))
                .collect(Collectors.toList());

        // 2. Redis 해시에서 게시글 데이터 조회
        List<PostResponse> posts = topPostIds.stream()
                .map(postId -> {
                    PostResponse postResponse = postRedisTemplateService.getPostFromCache(postId.toString());
                    return postResponse;
                })
                .filter(Objects::nonNull)
                .collect(Collectors.toList());

        // 3. Redis에 없는 데이터는 MySQL에서 조회 후 Redis에 캐시
        if (posts.size() < topPostIds.size()) {
            log.info("Redis 해시에서 조회되지 않은 게시글을 MySQL에서 조회합니다.");
            Set<Long> cachedPostIds = posts.stream().map(PostResponse::id).collect(Collectors.toSet());
            Set<Long> missingPostIds = topPostIds.stream()
                    .filter(postId -> !cachedPostIds.contains(postId))
                    .collect(Collectors.toSet());
            List<PostResponse> missingPosts = postRepository.findAllById(missingPostIds).stream()
                    .map(post -> PostResponse.from(post, userAccountRepository))
                    .toList();
            posts.addAll(missingPosts);
            // 조회한 Post를 Redis 해시에 캐시
            missingPosts.forEach(postRedisTemplateService::save);
        }

        return posts;
    }



    @Cacheable(value = "topPostIds", key = "#limit")
    public Set<Long> getTopPostIds(long limit) {
        ZSetOperations<String, Object> zSetOps = myredisTemplate.opsForZSet();
        Set<ZSetOperations.TypedTuple<Object>> topPostIdsWithScores = zSetOps.reverseRangeWithScores(POPULAR_POSTS_KEY, 0, limit - 1);
        Set<Long> topPostIds = Objects.requireNonNull(topPostIdsWithScores).stream()
                .map(typedTuple -> Long.valueOf(typedTuple.getValue().toString()))
                .collect(Collectors.toSet());
        return topPostIds;
    }
    private void initializeZSetWithAllPosts() {
        List<Post> allPosts = postRepository.findAll();
        ZSetOperations<String, Object> zSetOps = myredisTemplate.opsForZSet();

        for (Post post : allPosts) {
            long likeCount = post.getLikes().size();
            zSetOps.add(POPULAR_POSTS_KEY, post.getId().toString(), likeCount);

            // PostResponse 생성 및 Redis 해시에 저장
            PostResponse postResponse = PostResponse.from(post, userAccountRepository);
            postRedisTemplateService.save(postResponse);

            log.info("Added postId: {} with likeCount: {} to Redis", post.getId(), likeCount);
        }
    }


    /* 기존 로직 postman 테스트 시 1000ms가 넘음


    public List<PostResponse> getPopularPostsFromAllCategories(long limit) {
        // 1. 모든 게시글 조회
        List<Post> allPosts = postRepository.findAll();

        // 2. 좋아요 개수를 기준으로 내림차순 정렬
        allPosts.sort(Comparator.comparingInt((Post post) -> post.getLikes().size()).reversed());

        // 3. 원하는 개수만큼 선택하여 반환
        return allPosts.stream().map(post -> PostResponse.from(post, userAccountRepository)).limit(limit).collect(Collectors.toList());
        }
    */
}
