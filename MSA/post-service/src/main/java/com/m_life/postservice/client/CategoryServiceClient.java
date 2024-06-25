package com.m_life.postservice.client;

import com.m_life.postservice.dto.CategoryResponse;
import com.m_life.postservice.dto.UserResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@FeignClient(name = "category-service")
public interface CategoryServiceClient {
    @GetMapping("/category/{categoryId}")
    CategoryResponse getCategoryById(@PathVariable(name = "categoryId") Long categoryId);
}
