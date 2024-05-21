package com.m_life.m_life.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.m_life.m_life.domain.UserAccount;
import com.m_life.m_life.dto.request.PostRequest;
import com.m_life.m_life.dto.response.PostResponse;
import com.m_life.m_life.service.CustomUserDetails;
import com.m_life.m_life.service.PostService;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Objects;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/category")
public class PostController {

    private final PostService postService;
    private final Logger logger = LoggerFactory.getLogger(PostController.class);

    // 인기 게시글 조회
    @GetMapping("/popular-posts/{limit}")
    public ResponseEntity<List<PostResponse>> getPopularPosts(@PathVariable(name = "limit") Long limit) {
        List<PostResponse> popularPosts = postService.getPopularPostsFromAllCategories(limit);
        return ResponseEntity.ok(popularPosts);
    }

    // 게시판 카테고리별 게시글 조회
    @GetMapping("/{categoryId}")
    public ResponseEntity<List<PostResponse>> getPostsByCategory(@PathVariable(name = "categoryId") Long categoryId) {
        if (categoryId != 1) {
            List<PostResponse> posts = postService.getPostsByCategory(categoryId);
            return ResponseEntity.ok(posts);
        }
        return ResponseEntity.badRequest().body(null);
    }

    // 전체 게시글 조회(카테고리별로 대체 해야할듯)
    @GetMapping("/post")
    public List<PostResponse> getPosts() {
        return postService.getAllposts();
    }

    // 각각 게시글 조회
    @GetMapping("/post/{postid}")
    public PostResponse getPost(@PathVariable(name = "postid") Long id) {
        return postService.getMypost(id);
    }

    @PostMapping("/{categoryId}/post")
    public ResponseEntity<String> createPost(@PathVariable(name = "categoryId") Long categoryId,
                                             @RequestPart(value = "images", required = false) List<MultipartFile> files,
                                             @RequestPart("postRequest") String postRequestJson,
                                             @AuthenticationPrincipal CustomUserDetails userDetails) {
        if (categoryId != 1) {
//            logger.info("postRequestJson is: " + postRequestJson);
            ObjectMapper objectMapper = new ObjectMapper();
            PostRequest postRequest;
            try {
                postRequest = objectMapper.readValue(postRequestJson, PostRequest.class);
            } catch (JsonProcessingException e) {
                return ResponseEntity.badRequest().body("Invalid JSON format");
            }

//            logger.info("postRequest is: " + postRequest);
            UserAccount userAccount = userDetails.getUserAccount();
            return postService.save(postRequest, userAccount, categoryId, files);
        }
        return ResponseEntity.badRequest().body("인기 게시판에는 게시글 작성이 불가능합니다.");
    }
    @PutMapping("/{categoryId}/post/{postid}")
    public ResponseEntity<String> updatePost(@PathVariable(name = "categoryId") Long categoryId,
                                             @PathVariable(name = "postid") Long id,
                                             @RequestPart(value = "images", required = false) List<MultipartFile> files,
                                             @RequestPart("postRequest") String postRequestJson,
                                             @AuthenticationPrincipal CustomUserDetails userDetails) {
        if (categoryId != 1) {
            ObjectMapper objectMapper = new ObjectMapper();
            PostRequest postRequest;
            try {
                postRequest = objectMapper.readValue(postRequestJson, PostRequest.class);
            } catch (JsonProcessingException e) {
                return ResponseEntity.badRequest().body("Invalid JSON format");
            }

            UserAccount userAccount = userDetails.getUserAccount();
            return postService.update(postRequest, id, categoryId, userAccount, files);
        }
        return ResponseEntity.badRequest().body("인기 게시판에는 게시글 작성이 불가능합니다.");
    }

    @DeleteMapping("/post/{postid}")
    public ResponseEntity<String> deletePost(@PathVariable(name = "postid") Long id,
                                             @AuthenticationPrincipal CustomUserDetails userDetails) {
        UserAccount userAccount = userDetails.getUserAccount();
        return postService.delete(id, userAccount);
    }
}