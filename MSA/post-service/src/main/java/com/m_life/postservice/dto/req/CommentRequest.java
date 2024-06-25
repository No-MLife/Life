package com.m_life.postservice.dto.req;

public record CommentRequest(
        String content
) {
    public static CommentRequest of(String content){

        return new CommentRequest(content);
    }
}
