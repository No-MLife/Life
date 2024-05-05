package com.m_life.m_life.service;

import com.m_life.m_life.domain.Comment;
import com.m_life.m_life.domain.Post;
import com.m_life.m_life.domain.UserAccount;
import com.m_life.m_life.dto.request.CommentRequest;
import com.m_life.m_life.dto.response.CommentResponse;
import com.m_life.m_life.repository.CommentRepository;
import com.m_life.m_life.repository.PostRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CommentService {
    private final CommentRepository commentRepository;
    private final PostRepository postRepository;


    public ResponseEntity<String> save(CommentRequest commentRequest, Long postid, UserAccount userAccount) {
        boolean isPost = postRepository.existsById(postid);
        if (isPost) {
            Post post = postRepository.findById(postid).orElseThrow();
            Comment comment = Comment.of(
                    commentRequest.content(),
                    post,
                    userAccount
            );
            commentRepository.save(comment);
            return ResponseEntity.ok("댓글 작성이 완료되었습니다.");
        } else {
            return ResponseEntity.badRequest().body("게시글이 존재하지 않습니다.");
        }
    }

    public ResponseEntity<String> update(CommentRequest commentRequest, Long postid, Long commentid, UserAccount userAccount) {
        boolean isPost = postRepository.existsById(postid);
        boolean isComment = commentRepository.existsById(commentid);
        if (isPost && isComment) {
            Post post = postRepository.findById(postid).orElseThrow();
            Comment comment = commentRepository.findById(commentid).orElseThrow();

            // 로그인한 사용자와 댓글 작성자가 일치하는지 확인
            if (!comment.getUserAccount().equals(userAccount)) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body("댓글 수정 권한이 없습니다.");
            }

            if (commentRequest.content() != null) {
                comment.setContent(commentRequest.content());
            }
            commentRepository.save(comment);
            return ResponseEntity.ok("댓글 수정이 성공했습니다.");
        } else {
            return ResponseEntity.badRequest().body("게시글 또는 댓글이 존재하지 않습니다.");
        }
    }

    public ResponseEntity<String> delete(Long postid, Long commentid, UserAccount userAccount) {
        boolean isPost = postRepository.existsById(postid);
        boolean isComment = commentRepository.existsById(commentid);
        if (isPost && isComment) {
            Comment comment = commentRepository.findById(commentid).orElseThrow();

            // 로그인한 사용자와 댓글 작성자가 일치하는지 확인
            if (!comment.getUserAccount().equals(userAccount)) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body("댓글 삭제 권한이 없습니다.");
            }

            commentRepository.deleteById(commentid);
            return ResponseEntity.ok("댓글을 삭제했습니다.");
        } else {
            return ResponseEntity.badRequest().body("게시글 또는 댓글이 존재하지 않습니다.");
        }
    }

    public List<CommentResponse> getAllcomments(Long postid) {
        boolean isPost = postRepository.existsById(postid);
        if(isPost){
            Post post = postRepository.findById(postid).orElseThrow();
            return post.getCommentList().stream().map(CommentResponse::from).collect(Collectors.toList());
        }
        else{
            return  null;
        }
    }

    public CommentResponse getAllcomment(Long postid, Long commentid) {
        boolean isPost = postRepository.existsById(postid);
        if(isPost){
            if(commentRepository.existsById(commentid)){
                Comment comment = commentRepository.findById(commentid).orElseThrow();
                return CommentResponse.from(comment);
            }
        }
        return  null;
    }
}
