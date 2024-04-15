package com.m_life.m_life.dto.response;

import com.m_life.m_life.domain.Post;

import java.time.LocalDateTime;

public record PostResponse(
        int id,
        String title,
        String content,
        LocalDateTime createAt
) {
    public static PostResponse of(int id, String title, String content, LocalDateTime localDateTime){
        return new PostResponse(id, title, content, localDateTime);
    }

    public static PostResponse from(Post post){
        return new PostResponse(
                post.getId(),
                post.getTitle(),
                post.getContent(),
                post.getCreateDate()
        );
    }
}
