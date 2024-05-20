package com.m_life.m_life.service;

import com.m_life.m_life.domain.Post;
import com.m_life.m_life.domain.PostCategory;
import com.m_life.m_life.domain.PostImage;
import com.m_life.m_life.domain.UserAccount;
import com.m_life.m_life.dto.request.PostRequest;
import com.m_life.m_life.dto.response.PostResponse;
import com.m_life.m_life.repository.PostCategoryRepository;
import com.m_life.m_life.repository.PostRepository;
import com.m_life.m_life.repository.UserAccountRepository;
import jakarta.persistence.EntityNotFoundException;
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

@Slf4j
@RequiredArgsConstructor
@Service
public class PostService {
    private final PostRepository postRepository;
    private final PostCategoryRepository postCategoryRepository;
    private final UserAccountRepository userAccountRepository;
    private final S3Service s3service;

    public ResponseEntity<String> save(PostRequest postRequest, UserAccount userAccount, Long categoryId, List<MultipartFile> files) {

        PostCategory postCategory = postCategoryRepository.findById(categoryId)
                .orElseThrow(() -> new IllegalArgumentException("Invalid Category ID"));

        Post post = Post.of(postRequest.title(), postRequest.content(), postCategory);
        post.setUserAccount(userAccount);
        postRepository.save(post);

        if (files != null && !files.isEmpty()) { // 이미지가 있는 경우 이미지도 같이 저장
            s3service.uploadPostImages(files, post.getId());
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
            // 기존 이미지 삭제
            if (!post.getImages().isEmpty()) {
                for (PostImage image : post.getImages()) {
                    s3service.deleteImage(image.getS3Url());
                }
                post.getImages().clear();
            }
            PostCategory postCategory = postCategoryRepository.findById(categoryId)
                    .orElseThrow(() -> new IllegalArgumentException("Invalid Category ID"));
            post.setCategory(postCategory);

            if (files != null && !files.isEmpty()) { // 이미지가 있는 경우 이미지도 같이 저장
                s3service.uploadPostImages(files, post.getId());
            }

            postRepository.save(post);
            return ResponseEntity.ok("게시글 수정이 완료되었습니다.");
        } catch (EntityNotFoundException e) {
            return ResponseEntity.badRequest().body("존재하지 않은 게시글입니다.");
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body("잘못된 카테고리 ID입니다.");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("게시글 수정 중 오류가 발생했습니다.");
        }
    }


    public ResponseEntity<String> delete(Long id, UserAccount userAccount) {
        boolean isPost = postRepository.existsById(id);
        if (isPost) {
            Post post = postRepository.getReferenceById(id);
            if (!post.getUserAccount().equals(userAccount)) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body("삭제 권한이 없습니다.");
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
