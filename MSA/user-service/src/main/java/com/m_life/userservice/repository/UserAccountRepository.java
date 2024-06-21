package com.m_life.userservice.repository;

import com.m_life.userservice.domain.UserAccount;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserAccountRepository extends JpaRepository<UserAccount, Long> {
    Boolean existsByUserid(String userid);
    Boolean existsByNickname(String nickname);
    Boolean existsByEmail(String email);
    UserAccount findByUserid(String userid);
    UserAccount findByNickname(String nickname);
}
