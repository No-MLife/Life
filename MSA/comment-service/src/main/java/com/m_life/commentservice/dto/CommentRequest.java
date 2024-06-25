package com.m_life.commentservice.dto;

public record CommentRequest(
        String content
) {
    public static CommentRequest of(String content){

        return new CommentRequest(content);
    }
}
