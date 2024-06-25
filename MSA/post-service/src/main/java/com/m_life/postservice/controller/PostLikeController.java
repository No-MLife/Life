package com.m_life.postservice.controller;
import com.m_life.postservice.servcie.PostLikeService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
public class PostLikeController {
    private final PostLikeService postLikeService;

    @GetMapping("/postLike-service")
    public String status() {
        return "It's Working in postLike Micro Service";
    }

    // 좋아요 여부[GET]
    @GetMapping("users/{userId}/posts/{postId}/liked")
    public ResponseEntity<Boolean> isLikedByCurrentUser(@PathVariable(name = "postId") Long postId,
                                                        @PathVariable(name = "userId") Long userId
                                                        ) {
        boolean isLiked = postLikeService.isLikedByUser(userId , postId);
        return ResponseEntity.ok(isLiked);
    }

    // 좋아요[POST]
    @PostMapping("users/{userId}/posts/{postId}/like")
    public ResponseEntity<Void> likePost(@PathVariable(name = "postId") Long postId,
                                         @PathVariable(name = "userId") Long userId) {

        postLikeService.likePost(userId, postId);
        return ResponseEntity.ok().build();
    }

    // 좋아요 취소 [DELETE]
    @DeleteMapping("users/{userId}/posts/{postId}/unlike")
    public ResponseEntity<String> unlikePost(@PathVariable(name = "postId") Long postId,
                                           @PathVariable(name = "userId") Long userId) {
        return postLikeService.unlikePost(userId, postId);
    }
}