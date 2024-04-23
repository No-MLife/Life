package com.m_life.m_life.controller;

import com.m_life.m_life.domain.UserAccount;
import com.m_life.m_life.service.PostLikeService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/posts/{postId}/like")
@RequiredArgsConstructor
public class PostLikeController {
    private final PostLikeService postLikeService;


    @PostMapping
    public ResponseEntity<Void> likePost(@PathVariable Long postId, @AuthenticationPrincipal UserAccount userAccount) {
        postLikeService.likePost(postId, userAccount);
        return ResponseEntity.ok().build();
    }

    @DeleteMapping
    public ResponseEntity<Void> unlikePost(@PathVariable Long postId, @AuthenticationPrincipal UserAccount userAccount) {
        postLikeService.unlikePost(postId, userAccount);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/count")
    public ResponseEntity<Long> getLikeCount(@PathVariable Long postId) {
        long likeCount = postLikeService.getLikeCount(postId);
        return ResponseEntity.ok(likeCount);
    }

    @GetMapping("/liked")
    public ResponseEntity<Boolean> isLikedByCurrentUser(@PathVariable Long postId, @AuthenticationPrincipal UserAccount userAccount) {
        boolean isLiked = postLikeService.isLikedByUser(postId, userAccount);
        return ResponseEntity.ok(isLiked);
    }
}