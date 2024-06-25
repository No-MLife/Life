package com.m_life.postservice.repository;

import com.m_life.postservice.domain.Post;
import com.m_life.postservice.domain.PostLike;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PostLikeRepository extends JpaRepository<PostLike, Integer> {

    PostLike findByPostAndUserId(Post post, Long userId);

    boolean existsByPostAndUserId(Post post, Long userId);
}
