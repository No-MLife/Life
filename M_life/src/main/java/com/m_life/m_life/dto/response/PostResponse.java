package com.m_life.m_life.dto.response;

import com.m_life.m_life.domain.Comment;
import com.m_life.m_life.domain.Post;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

public record PostResponse(
        int id,
        String title,
        String content,
        LocalDateTime createAt,
        List<CommentResponse> commentList

) {
    public static PostResponse of(int id, String title, String content, LocalDateTime localDateTime, List<CommentResponse> commentList){
        return new PostResponse(id, title, content, localDateTime, commentList);
    }

    public static PostResponse from(Post post){
        return new PostResponse(
                post.getId(),
                post.getTitle(),
                post.getContent(),
                post.getCreateDate(),
                post.getCommentList().stream().map(CommentResponse::from).collect(Collectors.toList())
        );
    }
}
