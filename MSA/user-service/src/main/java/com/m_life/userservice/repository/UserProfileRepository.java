package com.m_life.userservice.repository;


import com.m_life.userservice.domain.UserAccount;
import com.m_life.userservice.domain.UserProfile;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserProfileRepository extends JpaRepository<UserProfile, Long > {
    Boolean existsByUserAccount(UserAccount userAccount);
    UserProfile findByUserAccount(UserAccount userAccount);
}