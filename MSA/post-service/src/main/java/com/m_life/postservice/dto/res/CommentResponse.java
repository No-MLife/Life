package com.m_life.postservice.dto.res;




import com.m_life.postservice.domain.Comment;

import java.time.LocalDateTime;

public record CommentResponse(
        Long id,
        String content,
        LocalDateTime createAt,
        Long postId,
        String commentAuthor

) {
    public static CommentResponse of(Long id, String content, LocalDateTime localDateTime, Long postId, String commentAuthor){
        return new CommentResponse(id, content, localDateTime, postId, commentAuthor);
    }

    public static CommentResponse from(Comment comment, String commentAuthor){
        return new CommentResponse(
                comment.getId(),
                comment.getContent(),
                comment.getCreateDate(),
                comment.getPost().getId(),
                commentAuthor
        );
    }
}
