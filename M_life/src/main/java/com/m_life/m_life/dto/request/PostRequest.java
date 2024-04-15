package com.m_life.m_life.dto.request;

public record PostRequest(
        String title,
        String content
) {
    public static PostRequest of(String title, String content){
        return new PostRequest(title, content);
    }
}
