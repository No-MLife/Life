package com.m_life.postservice.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;
import java.util.List;

@Data
public class PostRequest {
    @JsonProperty("id") private Long id; // 수정 요청 시 사용
    @JsonProperty("title") private String title;
    @JsonProperty("content") private String content;
    @JsonProperty("categoryId") private Long categoryId;
    @JsonProperty("userId") private Long userId;
    @JsonProperty("postImageUrls") private List<String>postImageUrls; // 수정 요청 시 사용
}
