package com.m_life.categoryservice.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.m_life.categoryservice.domain.PostCategory;
import jakarta.persistence.Column;
import lombok.Data;

@Data
@JsonInclude(JsonInclude.Include.NON_NULL)
public class CategoryResponse {
    private Long id;
    private String boardName;
    private String description;

    public CategoryResponse(Long id, String boardName, String description){
        this.id = id;
        this.boardName = boardName;
        this.description = description;
    }

    public static CategoryResponse from(PostCategory postCategory){
        return new CategoryResponse(
                postCategory.getId(),
                postCategory.getBoardName(),
                postCategory.getDescription()
        );
    }


}
