package com.m_life.categoryservice.controller;

import com.m_life.categoryservice.dto.CategoryResponse;
import com.m_life.categoryservice.servicec.PostCategoryService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequiredArgsConstructor
public class CategoryController {
    private final PostCategoryService postCategoryService;
    @GetMapping("/")
    public String health(){
        return "It's Working on the Category Service";
    }

    // 전체 카테고리 내용을 반환[GET]
    @GetMapping("/category")
    public ResponseEntity<List<CategoryResponse>> getAllCategory(){
        return postCategoryService.getAllCategory();
    }

    // 개별 카테고리 내용을 반환[GET]
    @GetMapping("/category/{categoryId}")
    public ResponseEntity<CategoryResponse> getCategory(@PathVariable(name = "categoryId") Long categoryId){
        return postCategoryService.getCategory(categoryId);
    }

}
