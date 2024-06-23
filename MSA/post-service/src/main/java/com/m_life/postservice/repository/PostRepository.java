package com.m_life.postservice.repository;

import com.m_life.postservice.domain.Post;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PostRepository extends JpaRepository<Post, Long> {
    List<Post> findAllByCategoryId(Long categoryId);
    List<Post> findAllByUserId(Long userId);
}
