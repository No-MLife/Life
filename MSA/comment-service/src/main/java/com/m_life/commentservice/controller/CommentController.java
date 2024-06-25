package com.m_life.commentservice.controller;


import com.m_life.commentservice.dto.CommentRequest;
import com.m_life.commentservice.dto.CommentResponse;
import com.m_life.commentservice.service.CommentService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;



@Slf4j
@RestController
@RequiredArgsConstructor
public class CommentController {
    private final CommentService commentService;

    @GetMapping("/")
    public String status() {
        return "It's Working in Comment Micro Service";
    }

    // ====================================================== GET =====================================================
//    // 게시글에 모든 댓글 조회[GET]
//    @GetMapping("/posts/{postId}/comments")
//    public List<CommentResponse> getComments(@PathVariable(name = "postId")Long postId){
//        return commentService.getAllComments(postId);
//    }
//
//    @GetMapping("/{postid}/comment/{commentid}")
//    public CommentResponse getComment(@PathVariable(name = "postid")Long postid,
//                                      @PathVariable(name = "commentid") Long commentid){
//        return commentService.getAllcomment(postid, commentid);
//    }
    // ====================================================== GET =====================================================

    // ====================================================== POST =====================================================
    @PostMapping("/users/{userId}/posts/{postId}/comments")
    public ResponseEntity<CommentResponse> createComment(@RequestBody CommentRequest commentRequest,
                                                @PathVariable(name = "postId") Long postId,
                                                @PathVariable(name = "userId") Long userId){
        log.info("댓글 작성중 ....[POST].....{}", commentRequest);
        return commentService.save(commentRequest, postId, userId);
    }
    // ====================================================== POST =====================================================
//
//
//    @PutMapping("/{postid}/comment/{commentid}")
//    public ResponseEntity<String> updateComment(@RequestBody CommentRequest commentRequest,
//                                                @PathVariable(name= "postid") Long postid,
//                                                @PathVariable(name = "commentid") Long commentid,
//                                                @AuthenticationPrincipal CustomUserDetails userDetails){
//        UserAccount userAccount = userDetails.getUserAccount();
//        return commentService.update(commentRequest, postid, commentid, userAccount);
//    }
//
//    @DeleteMapping("{postid}/comment/{commentid}")
//    public ResponseEntity<String> deleteComment(@PathVariable(name = "postid") Long postid,
//                                                @PathVariable(name = "commentid") Long commentid,
//                                                @AuthenticationPrincipal CustomUserDetails userDetails
//                                                ){
//        UserAccount userAccount = userDetails.getUserAccount();
//        return commentService.delete(postid, commentid, userAccount);
//    }


}
