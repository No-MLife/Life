package com.m_life.commentservice.service;

import com.m_life.commentservice.client.PostServiceClient;
import com.m_life.commentservice.client.UserServiceClient;
import com.m_life.commentservice.domain.Comment;
import com.m_life.commentservice.dto.CommentRequest;
import com.m_life.commentservice.dto.CommentResponse;
import com.m_life.commentservice.dto.PostResponse;
import com.m_life.commentservice.dto.UserResponse;
import com.m_life.commentservice.repository.CommentRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;


@Slf4j
@Service
@RequiredArgsConstructor
public class CommentService {
    private final CommentRepository commentRepository;
    private final PostServiceClient postServiceClient;
    private final UserServiceClient userServiceClient;


    public ResponseEntity<CommentResponse> save(CommentRequest commentRequest, Long postId, Long userId) {
        try {

            // step1. 유저 정보도 가져옴
            UserResponse userResponse = userServiceClient.getUserByUserId(userId);
            // step2. 게시글이 존재하는 경우 게시글에 댓글 등록
            Comment comment = Comment.of(
                    commentRequest.content(),
                    postId,
                    userId
            );
            commentRepository.save(comment);
            return ResponseEntity.ok(CommentResponse.from(comment, userResponse.getNickname()));

        }catch (Exception e) {
            log.error(e.getMessage());
            return ResponseEntity.badRequest().body(null);
        }
    }

//    public ResponseEntity<String> update(CommentRequest commentRequest, Long postid, Long commentid, UserAccount userAccount) {
//        boolean isPost = postRepository.existsById(postid);
//        boolean isComment = commentRepository.existsById(commentid);
//        if (isPost && isComment) {
//            Post post = postRepository.findById(postid).orElseThrow();
//            Comment comment = commentRepository.findById(commentid).orElseThrow();
//
//            // 로그인한 사용자와 댓글 작성자가 일치하는지 확인
//            if (!comment.getUserAccount().equals(userAccount)) {
//                return ResponseEntity.status(HttpStatus.FORBIDDEN).body("댓글 수정 권한이 없습니다.");
//            }
//
//            if (commentRequest.content() != null) {
//                comment.setContent(commentRequest.content());
//            }
//            commentRepository.save(comment);
//            return ResponseEntity.ok("댓글 수정이 성공했습니다.");
//        } else {
//            return ResponseEntity.badRequest().body("게시글 또는 댓글이 존재하지 않습니다.");
//        }
//    }
//
//    public ResponseEntity<String> delete(Long postid, Long commentid, UserAccount userAccount) {
//        boolean isPost = postRepository.existsById(postid);
//        boolean isComment = commentRepository.existsById(commentid);
//        if (isPost && isComment) {
//            Comment comment = commentRepository.findById(commentid).orElseThrow();
//
//            // 로그인한 사용자와 댓글 작성자가 일치하는지 확인
//            if (!comment.getUserAccount().equals(userAccount)) {
//                return ResponseEntity.status(HttpStatus.FORBIDDEN).body("댓글 삭제 권한이 없습니다.");
//            }
//
//            commentRepository.deleteById(commentid);
//            return ResponseEntity.ok("댓글을 삭제했습니다.");
//        } else {
//            return ResponseEntity.badRequest().body("게시글 또는 댓글이 존재하지 않습니다.");
//        }
//    }

//    public List<CommentResponse> getAllComments(Long postId) {
//        // step1. RestTemplate를 이용해서 게시글 정보 확인
////        boolean isPost = postRepository.existsById(postid);
//
//        // step2. 게시글이 있다면 해당 게시글에 있는 모든 댓글 가져오기
//        if(isPost){
//            Post post = postRepository.findById(postid).orElseThrow();
//            return post.getCommentList().stream().map(CommentResponse::from).collect(Collectors.toList());
//        }
//        else{
//            return  null;
//        }
//    }

//    public CommentResponse getAllcomment(Long postid, Long commentid) {
//        boolean isPost = postRepository.existsById(postid);
//        if(isPost){
//            if(commentRepository.existsById(commentid)){
//                Comment comment = commentRepository.findById(commentid).orElseThrow();
//                return CommentResponse.from(comment);
//            }
//        }
//        return  null;
//    }
}
