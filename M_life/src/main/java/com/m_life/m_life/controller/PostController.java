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
@RequestMapping("/api/v1/category/{categoryId}")
public class PostController {

    private final PostService postService;

    @GetMapping()
    public ResponseEntity<List<PostResponse>> getPostsByCategory(@PathVariable(name = "categoryId") Long categoryId) {
        List<PostResponse> posts = postService.getPostsByCategory(categoryId);
        System.out.println(posts);
        return ResponseEntity.ok(posts);
    }

    @PostMapping("/post")
    public ResponseEntity<String> createPost(@PathVariable(name = "categoryId") Long categoryId,
                                             @RequestBody PostRequest postRequest,
                                             @AuthenticationPrincipal CustomUserDetails userDetails) {
        UserAccount userAccount = userDetails.getUserAccount();
        return postService.save(postRequest, userAccount, categoryId);
    }

    @PutMapping("/post/{postid}")
    public ResponseEntity<String> updatePost(@RequestBody PostRequest postRequest,
                                             @PathVariable(name = "categoryId") Long categoryId,
                                             @PathVariable(name = "postid") Long id,
                                             @AuthenticationPrincipal CustomUserDetails userDetails){
        UserAccount userAccount = userDetails.getUserAccount();
        return postService.update(postRequest, id, categoryId, userAccount);
    }

    @DeleteMapping("/post/{postid}")
    public ResponseEntity<String> deletePost(
            @PathVariable(name = "categoryId") Long categoryId,
            @PathVariable(name= "postid") Long id,
                                             @AuthenticationPrincipal CustomUserDetails userDetails){
        UserAccount userAccount = userDetails.getUserAccount();
        return postService.delete(id, userAccount);
    }

    @GetMapping("/post")
    public List<PostResponse> getPosts(@PathVariable(name = "categoryId") Long categoryId){
        return postService.getAllposts();
    }

    @GetMapping("/post/{postid}")
    public PostResponse getPost(@PathVariable(name = "categoryId") Long categoryId,
                                @PathVariable(name = "postid") Long id){
        return postService.getMypost(id);
    }
}
