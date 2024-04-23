package com.m_life.m_life.controller;

import com.m_life.m_life.domain.UserAccount;
import com.m_life.m_life.dto.request.PostRequest;
import com.m_life.m_life.dto.response.PostResponse;
import com.m_life.m_life.service.CustomUserDetails;
import com.m_life.m_life.service.PostService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/post")
public class PostController {

    private final PostService postService;
    @PostMapping()
    public ResponseEntity<String> createPost(@RequestBody PostRequest postRequest,
                                             @AuthenticationPrincipal CustomUserDetails userDetails) {
        UserAccount userAccount = userDetails.getUserAccount();
        return postService.save(postRequest, userAccount);
    }

    @PutMapping("/{postid}")
    public ResponseEntity<String> updatePost(@RequestBody PostRequest postRequest,
                                             @PathVariable(name = "postid") Long id,
                                             @AuthenticationPrincipal CustomUserDetails userDetails){
        UserAccount userAccount = userDetails.getUserAccount();
        return postService.update(postRequest, id, userAccount);
    }

    @DeleteMapping("/{postid}")
    public ResponseEntity<String> deletePost(@PathVariable(name= "postid") Long id,
                                             @AuthenticationPrincipal CustomUserDetails userDetails){
        UserAccount userAccount = userDetails.getUserAccount();
        return postService.delete(id, userAccount);
    }

    @GetMapping()
    public List<PostResponse> getPosts(){
        return postService.getAllposts();
    }

    @GetMapping("/{postid}")
    public PostResponse getPost(@PathVariable(name = "postid") Long id){
        return postService.getMypost(id);
    }
}
