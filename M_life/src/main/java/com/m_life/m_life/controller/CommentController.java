package com.m_life.m_life.controller;

import com.m_life.m_life.domain.Comment;
import com.m_life.m_life.domain.UserAccount;
import com.m_life.m_life.dto.request.CommentRequest;
import com.m_life.m_life.dto.request.PostRequest;
import com.m_life.m_life.dto.response.CommentResponse;
import com.m_life.m_life.service.CommentService;
import com.m_life.m_life.service.CustomUserDetails;
import com.m_life.m_life.service.PostService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/post/")
public class CommentController {
    private final CommentService commentService;
    @PostMapping("/{postid}/comment")
    public ResponseEntity<CommentResponse> createComment(@RequestBody CommentRequest commentRequest,
                                                @PathVariable(name = "postid") Long postid,
                                                @AuthenticationPrincipal CustomUserDetails userDetails){
        UserAccount userAccount = userDetails.getUserAccount();
        return commentService.save(commentRequest, postid, userAccount);
    }

    @PutMapping("/{postid}/comment/{commentid}")
    public ResponseEntity<String> updateComment(@RequestBody CommentRequest commentRequest,
                                                @PathVariable(name= "postid") Long postid,
                                                @PathVariable(name = "commentid") Long commentid,
                                                @AuthenticationPrincipal CustomUserDetails userDetails){
        UserAccount userAccount = userDetails.getUserAccount();
        return commentService.update(commentRequest, postid, commentid, userAccount);
    }

    @DeleteMapping("{postid}/comment/{commentid}")
    public ResponseEntity<String> deleteComment(@PathVariable(name = "postid") Long postid,
                                                @PathVariable(name = "commentid") Long commentid,
                                                @AuthenticationPrincipal CustomUserDetails userDetails
                                                ){
        UserAccount userAccount = userDetails.getUserAccount();
        return commentService.delete(postid, commentid, userAccount);
    }

    @GetMapping("/{postid}/comment")
    public List<CommentResponse> getComments(@PathVariable(name = "postid")Long postid){
        return commentService.getAllcomments(postid);
    }

    @GetMapping("/{postid}/comment/{commentid}")
    public CommentResponse getComment(@PathVariable(name = "postid")Long postid,
                                            @PathVariable(name = "commentid") Long commentid){
        return commentService.getAllcomment(postid, commentid);
    }
}
