package com.m_life.m_life.repository;

import com.m_life.m_life.domain.UserAccount;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserAccountRepository extends JpaRepository<UserAccount, Long> {
    Boolean existsByUserid(String userid);
    UserAccount findByUserid(String userid);
}
