package com.m_life.userservice.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

@Data
@JsonInclude(JsonInclude.Include.NON_NULL)
public class PostResponse {
    private Long id;
    private String title;
    private String content;
    private LocalDateTime createAt;

    private int view_count;
    // 댓글 리스트
    private List<Objects> commentList = new ArrayList<>();
    private int likeCount;
    private String authorName;


    // 카테고리
    private String boardName;
    private String description;
    private Long categoryId;

    private Long authorLikes;
    private List<String> images = new ArrayList<>();


}
