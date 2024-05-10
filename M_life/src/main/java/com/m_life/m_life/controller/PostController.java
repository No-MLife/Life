package com.m_life.m_life.controller;

import com.m_life.m_life.domain.UserAccount;
import com.m_life.m_life.dto.request.PostRequest;
import com.m_life.m_life.dto.response.PostResponse;
import com.m_life.m_life.service.CustomUserDetails;
import com.m_life.m_life.service.PostService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/category")
public class PostController {

    private final PostService postService;

    @GetMapping("/popular-posts/{limit}")
    public ResponseEntity<List<PostResponse>> getPopularPosts(@PathVariable(name = "limit") Long limit) {
        List<PostResponse> popularPosts = postService.getPopularPostsFromAllCategories(limit);
        return ResponseEntity.ok(popularPosts);
    }

    @GetMapping("/{categoryId}")
    public ResponseEntity<List<PostResponse>> getPostsByCategory(@PathVariable(name = "categoryId") Long categoryId) {
        if(categoryId!=1){
            List<PostResponse> posts = postService.getPostsByCategory(categoryId);
            return ResponseEntity.ok(posts);
        }
        return ResponseEntity.badRequest().body(null);
    }

    @PostMapping("/{categoryId}/post")
    public ResponseEntity<String> createPost(@PathVariable(name = "categoryId") Long categoryId,
                                             @RequestBody PostRequest postRequest,
                                             @AuthenticationPrincipal CustomUserDetails userDetails) {
        if(categoryId != 1){
            UserAccount userAccount = userDetails.getUserAccount();
            return postService.save(postRequest, userAccount, categoryId);
        }
        return ResponseEntity.badRequest().body("인기 게시판에는 게시글 작성이 불가능합니다.");
    }

    @PutMapping("/{categoryId}/post/{postid}")
    public ResponseEntity<String> updatePost(@RequestBody PostRequest postRequest,
                                             @PathVariable(name = "categoryId") Long categoryId,
                                             @PathVariable(name = "postid") Long id,
                                             @AuthenticationPrincipal CustomUserDetails userDetails){
        if(categoryId != 1){
            UserAccount userAccount = userDetails.getUserAccount();
            return postService.update(postRequest, id, categoryId, userAccount);
        }
        return ResponseEntity.badRequest().body("인기 게시판에는 게시글 작성이 불가능합니다.");
    }

    @DeleteMapping("/{categoryId}/post/{postid}")
    public ResponseEntity<String> deletePost(
            @PathVariable(name = "categoryId") Long categoryId,
            @PathVariable(name= "postid") Long id,
                                             @AuthenticationPrincipal CustomUserDetails userDetails){
        UserAccount userAccount = userDetails.getUserAccount();
        return postService.delete(id, userAccount);
    }

    @GetMapping("/{categoryId}/post")
    public List<PostResponse> getPosts(@PathVariable(name = "categoryId") Long categoryId){
        return postService.getAllposts();
    }

    @GetMapping("/{categoryId}/post/{postid}")
    public PostResponse getPost(@PathVariable(name = "categoryId") Long categoryId,
                                @PathVariable(name = "postid") Long id){
        return postService.getMypost(id);
    }
}
