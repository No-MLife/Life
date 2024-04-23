package com.m_life.m_life.repository;

import com.m_life.m_life.domain.Post;
import com.m_life.m_life.domain.PostLike;
import com.m_life.m_life.domain.UserAccount;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface PostLikeRepository extends JpaRepository<PostLike, Integer> {

    PostLike findByPostAndUserAccount(Post post, UserAccount userAccount);

    boolean existsByPostAndUserAccount(Post post, UserAccount userAccount);
}
