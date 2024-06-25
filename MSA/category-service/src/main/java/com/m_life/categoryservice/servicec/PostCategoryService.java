package com.m_life.categoryservice.servicec;

import com.m_life.categoryservice.domain.PostCategory;
import com.m_life.categoryservice.dto.CategoryResponse;
import com.m_life.categoryservice.repository.PostCategoryRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class PostCategoryService {
    private final PostCategoryRepository postCategoryRepository;

    // READ
    @Transactional(readOnly = true)
    public ResponseEntity<List<CategoryResponse>> getAllCategory(){
        return ResponseEntity.ok().body(postCategoryRepository.findAll().stream().map(CategoryResponse::from).collect(Collectors.toList()));
    }

    public ResponseEntity<CategoryResponse> getCategory(Long categoryId) {
        PostCategory postCategory = postCategoryRepository.findById(categoryId).orElseThrow(
                () -> new ResponseStatusException(HttpStatus.NOT_FOUND)
        );
        return ResponseEntity.ok().body(CategoryResponse.from(postCategory));
    }


}
