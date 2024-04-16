package com.m_life.m_life.dto.response;

import com.m_life.m_life.domain.Comment;
import com.m_life.m_life.domain.Post;

import java.time.LocalDateTime;
import java.util.List;

public record CommentResponse(
        int id,
        String content,
        LocalDateTime createAt,
        int postId

) {
    public static CommentResponse of(int id, String content, LocalDateTime localDateTime, int postId){
        return new CommentResponse(id, content, localDateTime, postId);
    }

    public static CommentResponse from(Comment comment){
        return new CommentResponse(
                comment.getId(),
                comment.getContent(),
                comment.getCreateDate(),
                comment.getPost().getId()
        );
    }
}
