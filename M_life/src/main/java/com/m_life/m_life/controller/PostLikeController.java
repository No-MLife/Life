package com.m_life.m_life.controller;

import com.m_life.m_life.domain.UserAccount;
import com.m_life.m_life.service.CustomUserDetails;
import com.m_life.m_life.service.PostLikeService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/post/{postId}/like")
@RequiredArgsConstructor
public class PostLikeController {
    private final PostLikeService postLikeService;


    @PostMapping
    public ResponseEntity<Void> likePost(@PathVariable(name = "postId") Long postId,
                                         @AuthenticationPrincipal CustomUserDetails userDetails) {

        UserAccount userAccount = userDetails.getUserAccount();
        postLikeService.likePost(postId, userAccount);
        return ResponseEntity.ok().build();
    }

    @DeleteMapping
    public ResponseEntity<Void> unlikePost(@PathVariable(name = "postId") Long postId,
                                           @AuthenticationPrincipal CustomUserDetails userDetails) {
        UserAccount userAccount = userDetails.getUserAccount();
        postLikeService.unlikePost(postId, userAccount);
        return ResponseEntity.ok().build();
    }


    @GetMapping("/liked")
    public ResponseEntity<Boolean> isLikedByCurrentUser(@PathVariable(name = "postId") Long postId,
                                                        @AuthenticationPrincipal CustomUserDetails userDetails) {
        UserAccount userAccount = userDetails.getUserAccount();
        boolean isLiked = postLikeService.isLikedByUser(postId, userAccount);
        return ResponseEntity.ok(isLiked);
    }
}