package com.m_life.m_life.dto.request;

import com.fasterxml.jackson.annotation.JsonProperty;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

public record PostRequest(
        @JsonProperty("id") long id,
        @JsonProperty("title") String title,
        @JsonProperty("content") String content,
        @JsonProperty("boardName") String boardName,

        @JsonProperty("postImageUrls") List<String>postImageUrls

) {


    public static PostRequest of(long id, String title, String content, String boardName, List<String>postImageUrls){
        return new PostRequest(id, title, content, boardName, postImageUrls);
    }
}
