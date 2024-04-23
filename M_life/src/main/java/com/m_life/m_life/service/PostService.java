package com.m_life.m_life.service;

import com.m_life.m_life.domain.Post;
import com.m_life.m_life.domain.UserAccount;
import com.m_life.m_life.dto.request.PostRequest;
import com.m_life.m_life.dto.response.PostResponse;
import com.m_life.m_life.repository.PostRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@RequiredArgsConstructor
@Service
public class PostService {
    private final PostRepository postRepository;

    public ResponseEntity<String>save(PostRequest postRequest, UserAccount userAccount){
        Post post = Post.of(
                postRequest.title(), postRequest.content()
        );
        post.setUserAccount(userAccount);
        postRepository.save(post);
        return ResponseEntity.ok("게시글 작성이 완료되었습니다.");
    }

    public ResponseEntity<String> update(PostRequest postRequest, Long id, UserAccount userAccount) {
        try {
            Post post = postRepository.getReferenceById(id);
            if (!post.getUserAccount().equals(userAccount)) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body("수정 권한이 없습니다.");
            }
            if (postRequest.title() != null) {
                post.setTitle(postRequest.title());
            }
            if (postRequest.content() != null) {
                post.setContent(postRequest.content());
            }
            post.setUserAccount(userAccount);
            postRepository.save(post);
            return ResponseEntity.ok("게시글 수정이 성공했습니다.");
        } catch (EntityNotFoundException e) {
            log.warn("게시글 정보를 찾지 못했습니다.");
            return ResponseEntity.badRequest().body("존재하지 않은 게시글입니다.");
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
        return postRepository.findAll().stream().map(PostResponse::from).collect(Collectors.toList());
    }

    public PostResponse getMypost(Long id) {
        boolean isPost = postRepository.existsById(id);
        if (isPost){
            Post post = postRepository.findById(id).orElseThrow();
            return PostResponse.from(post);
        }
        else{
            return null;
        }
    }
}
