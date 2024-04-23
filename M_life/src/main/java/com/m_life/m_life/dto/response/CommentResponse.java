package com.m_life.m_life.dto.response;

import com.m_life.m_life.domain.Comment;
import com.m_life.m_life.domain.Post;

import java.time.LocalDateTime;
import java.util.List;

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

    public static CommentResponse from(Comment comment){
        return new CommentResponse(
                comment.getId(),
                comment.getContent(),
                comment.getCreateDate(),
                comment.getPost().getId(),
                comment.getUserAccount().getNickname()
        );
    }
}
