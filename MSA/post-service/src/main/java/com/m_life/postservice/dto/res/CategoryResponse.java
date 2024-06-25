package com.m_life.postservice.dto.res;

import com.fasterxml.jackson.annotation.JsonInclude;
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

    public CategoryResponse(){

    }



}
