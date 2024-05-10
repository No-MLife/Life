package com.m_life.m_life.repository;

import com.m_life.m_life.domain.PostCategory;
import com.m_life.m_life.domain.Post;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PostRepository extends JpaRepository<Post, Long> {
    List<Post> findAllByOrderByCreateDateDesc();
    List<Post> findByCategoryId(Long categoryId);

}
