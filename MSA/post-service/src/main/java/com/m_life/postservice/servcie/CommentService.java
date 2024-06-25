package com.m_life.postservice.servcie;

import com.m_life.postservice.client.UserServiceClient;
import com.m_life.postservice.domain.Comment;
import com.m_life.postservice.domain.Post;
import com.m_life.postservice.dto.req.CommentRequest;
import com.m_life.postservice.dto.res.CommentResponse;
import com.m_life.postservice.dto.res.UserResponse;
import com.m_life.postservice.repository.CommentRepository;
import com.m_life.postservice.repository.PostRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.stream.Collectors;


@Slf4j
@Service
@RequiredArgsConstructor
public class CommentService {
    private final CommentRepository commentRepository;
    private final UserServiceClient userServiceClient;
    private final PostRepository postRepository;


    // 게시글에 달린 전체 댓글 조회[READ]
    @Transactional(readOnly = true)
    public ResponseEntity<List<CommentResponse>> getAllCommentsByPostID(Long postId) {
        boolean isPost = postRepository.existsById(postId);
        if(isPost){
            Post post = postRepository.findById(postId).orElseThrow();
            UserResponse userResponse = userServiceClient.getUserByUserId(post.getUserId());
            return ResponseEntity.ok().body(post.getCommentList().stream().map(
                    comment -> CommentResponse.from(comment, userResponse.getNickname())
            ).collect(Collectors.toList()));
        }
        else{
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
        }
    }

    // 유저가 작성한 전체 댓글 조회[READ]
    @Transactional(readOnly = true)
    public ResponseEntity<List<CommentResponse>> getAllCommentsByUserId(Long userId) {
        UserResponse userResponse = userServiceClient.getUserByUserId(userId);
        if (userResponse!=null) {
            List<Comment> commentList = commentRepository.findAllByUserID(userId);
            return ResponseEntity.ok().body(commentList.stream().map(
                    comment -> CommentResponse.from(comment, userResponse.getNickname())
            ).collect(Collectors.toList()));
        }
        else{
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
        }
    }

    // 유저가 특정 게시글에 댓글 생성 [CREATE]
    @Transactional
    public ResponseEntity<CommentResponse> save(CommentRequest commentRequest, Long postId, Long userId) {
        try {
            Post post = postRepository.findById(postId).orElseThrow(
                    () -> new ResponseStatusException(HttpStatus.NOT_FOUND, "게시글이 존재하지 않습니다.")
            );
            // step1. 유저 정보도 가져옴
            UserResponse userResponse = userServiceClient.getUserByUserId(userId);
            // step2. 게시글이 존재하는 경우 게시글에 댓글 등록
            Comment comment = Comment.of(
                    commentRequest.content(),
                    post,
                    userId
            );
            commentRepository.save(comment);
            return ResponseEntity.status(HttpStatus.CREATED).body(CommentResponse.from(comment, userResponse.getNickname()));

        }catch (Exception e) {
            log.error(e.getMessage());
            return ResponseEntity.badRequest().body(null);
        }
    }

    // 유저가 특정 게시글에 댓글 수정 [UPDATE]
    @Transactional
    public ResponseEntity<String> update(CommentRequest commentRequest, Long userId, Long postId, Long commentId) {
        boolean isPost = postRepository.existsById(postId);
        boolean isComment = commentRepository.existsById(commentId);
        if (isPost && isComment) {
            UserResponse userResponse = userServiceClient.getUserByUserId(userId);
            Post post = postRepository.findById(postId).orElseThrow();
            Comment comment = commentRepository.findById(commentId).orElseThrow();

            // 로그인한 사용자와 댓글 작성자가 일치하는지 확인
            if (!comment.getUserID().equals(userResponse.getId())) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body("댓글 수정 권한이 없습니다.");
            }

            if (commentRequest.content() != null) {
                comment.setContent(commentRequest.content());
            }
            commentRepository.save(comment);
            return ResponseEntity.status(HttpStatus.NO_CONTENT).body("");
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("게시글 또는 댓글이 존재하지 않습니다.");
        }
    }

    // 유저가 특정 게시글에 댓글 삭제 [DELETE]
    @Transactional
    public ResponseEntity<String> delete(Long userId, Long postId, Long commentId) {
        boolean isPost = postRepository.existsById(postId);
        boolean isComment = commentRepository.existsById(commentId);
        if (isPost && isComment) {
            Comment comment = commentRepository.findById(commentId).orElseThrow();
            UserResponse userResponse = userServiceClient.getUserByUserId(userId);
            // 로그인한 사용자와 댓글 작성자가 일치하는지 확인
            if (!comment.getUserID().equals(userResponse.getId())) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body("댓글 삭제 권한이 없습니다.");
            }
            commentRepository.deleteById(commentId);
            return ResponseEntity.status(HttpStatus.NO_CONTENT).body("");
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("게시글 또는 댓글이 존재하지 않습니다.");
        }
    }

    

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
