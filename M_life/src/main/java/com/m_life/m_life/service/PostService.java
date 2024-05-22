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
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.util.Comparator;
import java.util.List;
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
            Post post = postRepository.findById(id)
                    .orElseThrow(() -> new IllegalArgumentException("Invalid post ID"));

            if (!post.getUserAccount().equals(userAccount)) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body("수정 권한이 없습니다.");
            }

            if (postRequest.title() != null) {
                post.setTitle(postRequest.title());
            }

            if (postRequest.content() != null) {
                post.setContent(postRequest.content());
            }

            PostCategory postCategory = postCategoryRepository.findById(categoryId)
                    .orElseThrow(() -> new IllegalArgumentException("Invalid Category ID"));
            post.setCategory(postCategory);

            // 새로운 이미지 URL 수집
            List<String> newImageUrls = (files != null && !files.isEmpty()) ?
                    s3Service.uploadPostImages(files, post.getId()) :
                    List.of();

            // 기존 이미지와 새로운 이미지 비교하여 삭제된 이미지 식별
            List<PostImage> imagesToDelete = post.getImages().stream()
                    .filter(image -> !newImageUrls.contains(image.getS3Url())) // 새로운 URL에 포함되지 않은 기존 이미지 필터링
                    .collect(Collectors.toList());

            for (PostImage image : imagesToDelete) {
                s3Service.deleteImage(image.getS3Url());
            }

            postImageRepository.deleteAll(imagesToDelete);
            post.getImages().removeAll(imagesToDelete);

            // 새로운 이미지 업로드 및 포스트에 추가
            if (files != null && !files.isEmpty()) {
                List<PostImage> uploadedImages = IntStream.range(0, newImageUrls.size())
                        .mapToObj(i -> PostImage.of(files.get(i).getOriginalFilename(), newImageUrls.get(i), post))
                        .toList();
                post.getImages().addAll(uploadedImages);
            }

            postRepository.save(post);
            return ResponseEntity.ok("게시글 수정이 완료되었습니다.");
        } catch (Exception e) {
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
        // 1. 모든 게시글 조회
        List<Post> allPosts = postRepository.findAll();

        // 2. 좋아요 개수를 기준으로 내림차순 정렬
        allPosts.sort(Comparator.comparingInt((Post post) -> post.getLikes().size()).reversed());

        // 3. 원하는 개수만큼 선택하여 반환
        return allPosts.stream().map(post -> PostResponse.from(post, userAccountRepository)).limit(limit).collect(Collectors.toList());
    }


}
