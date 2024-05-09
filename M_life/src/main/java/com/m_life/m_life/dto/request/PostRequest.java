package com.m_life.m_life.dto.request;

public record PostRequest(
        long id,
        String title,
        String content,
        String boardName

) {
    public static PostRequest of(long id, String title, String content, String boardName){
        return new PostRequest(id, title, content, boardName);
    }
}
