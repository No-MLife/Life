package com.m_life.m_life.controller;

import com.m_life.m_life.domain.Comment;
import com.m_life.m_life.dto.request.CommentRequest;
import com.m_life.m_life.dto.request.PostRequest;
import com.m_life.m_life.dto.response.CommentResponse;
import com.m_life.m_life.service.CommentService;
import com.m_life.m_life.service.PostService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/post/")
public class CommentController {
    private final CommentService commentService;
    @PostMapping("/{postid}/comment")
    public ResponseEntity<String> createComment(@RequestBody CommentRequest commentRequest, @PathVariable(name = "postid") Integer postid){
        return commentService.save(commentRequest, postid);
    }

    @PutMapping("/{postid}/comment/{commentid}")
    public ResponseEntity<String> updateComment(@RequestBody CommentRequest commentRequest,
                                                @PathVariable(name= "postid") Integer postid,
                                                @PathVariable(name = "commentid") Integer commentid){
        return commentService.update(commentRequest, postid, commentid);
    }

    @DeleteMapping("{postid}/comment/{commentid}")
    public ResponseEntity<String> deleteComment(@PathVariable(name = "postid") Integer postid,
                                                @PathVariable(name = "commentid") Integer commentid){
        return commentService.delete(postid, commentid);
    }

    @GetMapping("/{postid}/comment")
    public List<CommentResponse> getComments(@PathVariable(name = "postid")Integer postid){
        return commentService.getAllcomments(postid);
    }
}
