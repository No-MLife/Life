package com.m_life.m_life.repository;

import com.m_life.m_life.domain.UserAccount;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UserAccountRepository extends JpaRepository<UserAccount, Long> {
    Boolean existsByUserid(String userid);
    Boolean existsByNickname(String nickname);
    UserAccount findByUserid(String userid);
    @EntityGraph(attributePaths = {"likedPosts"})
    Optional<UserAccount> findWithLikedPostsById(Long id);

    @EntityGraph(attributePaths = {"likedPosts"})
    Optional<UserAccount> findWithLikedPostsByNickname(String nickname);
}
