package com.m_life.m_life.dto.request;

public record CommentRequest(
        String content
) {
    public static CommentRequest of(String content){

        return new CommentRequest(content);
    }
}
