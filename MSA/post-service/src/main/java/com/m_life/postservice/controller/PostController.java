package com.m_life.postservice.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.m_life.postservice.dto.PostRequest;
import com.m_life.postservice.dto.PostResponse;
import com.m_life.postservice.servcie.PostService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping(value = "/post-service/")
public class PostController {
    private final PostService postService;
    private final ObjectMapper objectMapper;
    @GetMapping(value = "/")
    public String health_check(){
        return "It's Working on post-service";
    }

    // ====================================================== GET =====================================================

    // 게시글 id로 조회[GET]
    @GetMapping(value = "/posts/{postId}")
    public ResponseEntity<PostResponse> getPostById(@PathVariable(name = "postId") Long postId){
        return postService.getPostById(postId);
    }

    // 유저별 게시글 전체 조회[GET]
    @GetMapping(value = "/users/{userId}/posts")
    public ResponseEntity<List<PostResponse>> getPostsByUserId(@PathVariable(name = "userId") Long userId){
        return postService.getPostsByUserId(userId);
    }

    // 카테고리별 게시글 전체 조회[GET]
    @GetMapping(value = "/category/{categoryId}")
    public ResponseEntity<List<PostResponse>> getPostsByCategory(@PathVariable(name = "categoryId") Long categoryId){
        if (categoryId != 1) {
            return postService.getPostsByCategory(categoryId);
        }
        return ResponseEntity.badRequest().body(null);
    }
    // ====================================================== GET =====================================================



    // ====================================================== POST ====================================================
    // 게시글 생성[POST]
    @PostMapping(value = "users/{userId}/category/{categoryId}/posts")
    public ResponseEntity<String> createPost(@PathVariable(name = "userId") Long userId,
                                             @PathVariable(name = "categoryId")Long categoryId,
                                             @RequestPart(value = "images", required = false) List<MultipartFile> files,
                                             @RequestPart("postRequest") String postJson){
        log.info("[POST] 게시글 작성중........");
        if (categoryId != 1) {
            // 인기게시글이 아니라면 작성 RequestPost -> DTO로 변환
            log.info("현재 들어온 post 정보 {}", postJson);
            PostRequest postRequest;
            try {
                postRequest = objectMapper.readValue(postJson, PostRequest.class);
            } catch (JsonProcessingException e) {
                return ResponseEntity.badRequest().body("Invalid JSON format");
            }
            postRequest.setCategoryId(categoryId);
            postRequest.setUserId(userId);
            log.info("현재 변환된 dto 정보 : {}", postRequest.toString());
            return postService.createPost(postRequest, files);
        }
        return ResponseEntity.badRequest().body("인기 게시판에는 게시글 작성이 불가능합니다.");
    }
    // ====================================================== POST ====================================================


    // ====================================================== PUT ====================================================
    @PutMapping("users/{userId}/category/{categoryId}/posts/{postId}")
    public ResponseEntity<String> updatePost(@PathVariable(name = "userId") Long userId,
                                             @PathVariable(name = "categoryId")Long categoryId,
                                             @PathVariable(name = "postId")Long postId,
                                             @RequestPart(value = "images", required = false) List<MultipartFile> files,
                                             @RequestPart("postRequest") String postJson) {
        // 디버깅용 프린트문 추가
        log.info("[PUT] 게시글 수정중........");
        if (categoryId != 1) {
            // 인기게시글이 아니라면 작성 RequestPost -> DTO로 변환
            log.info("현재 들어온 post 정보 {}", postJson);
            PostRequest postRequest;
            try {
                postRequest = objectMapper.readValue(postJson, PostRequest.class);
            } catch (JsonProcessingException e) {
                return ResponseEntity.badRequest().body("Invalid JSON format");
            }
            postRequest.setId(postId);
            postRequest.setCategoryId(categoryId);
            postRequest.setUserId(userId);

            List<String> imageUrls = files.stream()
                    .map(MultipartFile::getOriginalFilename)
                    .collect(Collectors.toList());
            postRequest.setPostImageUrls(imageUrls);
            return postService.updatePost(postRequest, files);
        }
        return ResponseEntity.badRequest().body("인기 게시판에는 게시글 작성이 불가능합니다.");
    }
    // ====================================================== PUT ====================================================

    // ====================================================== DELETE ====================================================
    @DeleteMapping("users/{userId}/posts/{postId}")
    public ResponseEntity<String> deletePost(@PathVariable(name = "postId") Long postId,
                                             @PathVariable(name = "userId") Long userId) {
        return postService.delete(userId, postId);
    }
    // ====================================================== DELETE ====================================================

}
