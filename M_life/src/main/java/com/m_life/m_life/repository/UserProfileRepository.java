package com.m_life.m_life.repository;

import com.m_life.m_life.domain.UserAccount;
import com.m_life.m_life.domain.UserProfile;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UserProfileRepository extends JpaRepository<UserProfile, Long > {
    Boolean existsByUserAccount(UserAccount userAccount);
    UserProfile findByUserAccount(UserAccount userAccount);
}
