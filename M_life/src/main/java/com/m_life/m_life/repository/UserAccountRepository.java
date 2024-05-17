package com.m_life.m_life.repository;

import com.m_life.m_life.domain.UserAccount;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;

public interface UserAccountRepository extends JpaRepository<UserAccount, Long> {
    Boolean existsByUserid(String userid);
    Boolean existsByNickname(String nickname);
    UserAccount findByUserid(String userid);
    UserAccount findByNickname(String nickname);

    @Query("SELECT SUM(SIZE(p.likes)) FROM UserAccount u LEFT JOIN u.posts p WHERE u.nickname = :nickname")
    Long getTotalLikeCountByNickname(@Param("nickname") String nickname);

}
