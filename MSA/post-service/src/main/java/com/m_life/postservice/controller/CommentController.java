package com.m_life.postservice.controller;


import com.m_life.postservice.dto.req.CommentRequest;
import com.m_life.postservice.dto.res.CommentResponse;
import com.m_life.postservice.servcie.CommentService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@Slf4j
@RestController
@RequiredArgsConstructor
public class CommentController {
    private final CommentService commentService;

    @GetMapping("/comment-service")
    public String status() {
        return "It's Working in Comment Micro Service";
    }

    // ====================================================== GET =====================================================
    // 게시글에 모든 댓글 조회[GET]
    @GetMapping("/posts/{postId}/comments")
    public ResponseEntity<List<CommentResponse>> getAllCommentsByPostId(@PathVariable(name = "postId")Long postId){
        return commentService.getAllCommentsByPostID(postId);
    }

    // 유저가 작성한 모든 댓글 조회[GET]
    @GetMapping("/users/{userId}/comments")
    public ResponseEntity<List<CommentResponse>> getAllCommentsByUserId(@PathVariable(name = "userId")Long userId){
        return commentService.getAllCommentsByUserId(userId);
    }

    // ====================================================== GET =====================================================

    // ====================================================== POST =====================================================
    // 게시글에 댓글 작성[POST]
    @PostMapping("/users/{userId}/posts/{postId}/comments")
    public ResponseEntity<CommentResponse> createComment(@RequestBody CommentRequest commentRequest,
                                                         @PathVariable(name = "postId") Long postId,
                                                         @PathVariable(name = "userId") Long userId){
        log.info("댓글 작성중 ....[POST].....{}", commentRequest);
        return commentService.save(commentRequest, postId, userId);
    }
    // ====================================================== POST =====================================================


    // ====================================================== PUT =====================================================
    // 게시글에 달린 댓글 수정[PUT]
    @PutMapping("/users/{userId}/posts/{postId}/comments/{commentId}")
    public ResponseEntity<String> updateComment(@RequestBody CommentRequest commentRequest,
                                                @PathVariable(name = "userId")Long usrId,
                                                @PathVariable(name= "postId") Long postId,
                                                @PathVariable(name = "commentId") Long commentId
                                              ){
        return commentService.update(commentRequest, usrId, postId, commentId);
    }
    // ====================================================== PUT =====================================================

    // ====================================================== DELETE =====================================================

    @DeleteMapping("/users/{userId}/posts/{postId}/comments/{commentId}")
    // 게시글에 달린 댓글 삭제[DELETE]
    public ResponseEntity<String> deleteComment(@PathVariable(name = "postId") Long postId,
                                                @PathVariable(name = "commentId") Long commentId,
                                                @PathVariable(name = "userId") Long userId
                                                ){
        return commentService.delete(userId, postId, commentId);
    }
    // ====================================================== DELETE =====================================================

}
