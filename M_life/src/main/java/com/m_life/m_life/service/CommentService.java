package com.m_life.m_life.service;

import com.m_life.m_life.domain.Comment;
import com.m_life.m_life.domain.Post;
import com.m_life.m_life.dto.request.CommentRequest;
import com.m_life.m_life.dto.response.CommentResponse;
import com.m_life.m_life.repository.CommentRepository;
import com.m_life.m_life.repository.PostRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CommentService {
    private final CommentRepository commentRepository;
    private final PostRepository postRepository;


    public ResponseEntity<String> save(CommentRequest commentRequest, Integer postid) {
        boolean isPost = postRepository.existsById(postid);
        if(isPost){
            Post post = postRepository.findById(postid).orElseThrow();
            Comment comment = Comment.of(
                    commentRequest.content(),
                    post
            );
            commentRepository.save(comment);
            return ResponseEntity.ok("댓글 작성이 완료되었습니다.");
        }
        else{
            return ResponseEntity.badRequest().body("게시글이 존재하지 않습니다.");
        }
    }

    public ResponseEntity<String> update(CommentRequest commentRequest, Integer postid, Integer commentid) {
        boolean isPost = postRepository.existsById(postid);
        boolean isComment = commentRepository.existsById(commentid);
        if(isPost && isComment){
            Post post = postRepository.findById(postid).orElseThrow();
            Comment comment = commentRepository.findById(commentid).orElseThrow();

            if (commentRequest.content() != null){comment.setContent(commentRequest.content());}
            commentRepository.save(comment);
            return ResponseEntity.ok("댓글 수정이 성공했습니다.");
            
        }
        else{
            return ResponseEntity.badRequest().body("게시글 또는 댓글이 존재하지 않습니다.");
        }
    }

    public ResponseEntity<String> delete(Integer postid, Integer commentid) {
        boolean isPost = postRepository.existsById(postid);
        boolean isComment = commentRepository.existsById(commentid);
        if(isPost && isComment){
            commentRepository.deleteById(commentid);
            return ResponseEntity.ok("댓글을 삭제했습니다.");
        }
        else{
            return ResponseEntity.badRequest().body("게시글 또는 댓글이 존재하지 않습니다.");
        }
    }

    public List<CommentResponse> getAllcomments(Integer postid) {
        boolean isPost = postRepository.existsById(postid);
        if(isPost){
            Post post = postRepository.findById(postid).orElseThrow();
            return post.getCommentList().stream().map(CommentResponse::from).collect(Collectors.toList());
        }
        else{
            return  null;
        }
    }
}
