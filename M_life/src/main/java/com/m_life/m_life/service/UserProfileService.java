package com.m_life.m_life.service;

import com.m_life.m_life.domain.UserAccount;
import com.m_life.m_life.domain.UserProfile;
import com.m_life.m_life.dto.response.UserProfileResponse;
import com.m_life.m_life.repository.UserAccountRepository;
import com.m_life.m_life.repository.UserProfileRepository;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
@RequiredArgsConstructor
public class UserProfileService {
    private final UserProfileRepository userProfileRepository;
    private final UserAccountRepository userAccountRepository;
    private Logger logger = LoggerFactory.getLogger(UserProfileService.class);


    @Transactional(readOnly = true)
    public UserProfileResponse getUserProfile(String nick_name) {
        // step1. 유저에 대한 정보를 가져온 후 닉네임에 맞게 재 탐색
        UserAccount userAccount = userAccountRepository.findByNickname(nick_name);
        logger.info("user account: {}", userAccount);
        logger.info("user nickname is : {}", userAccount.getNickname());

        // step2. 해당 유저가 존재한다면 다음으로 진행
        if(userProfileRepository.existsByUserAccount(userAccount)){
            UserProfile userProfile = userProfileRepository.findByUserAccount(userAccount);
            logger.info("HERE: {}");
            return UserProfileResponse.from(userProfile);
        }
        else{
            return null;
        }
    }

//    public UserProfile createUserProfile(Long userId, UserProfileRequest request) {
//        UserAccount userAccount = userAccountRepository.findById(userId)
//                .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + userId));
//
//        UserProfile userProfile = new UserProfile();
//        userProfile.setUserAccount(userAccount);
//        userProfile.setProfileImageUrl(request.getProfileImageUrl());
//        userProfile.setIntroduction(request.getIntroduction());
//        userProfile.setLocation(request.getLocation());
//        userProfile.setWebsite(request.getWebsite());
//
//        return userProfileRepository.save(userProfile);
//    }
//
//    public UserProfile updateUserProfile(Long userId, UserProfileRequest request) {
//        UserProfile userProfile = getUserProfile(userId);
//        userProfile.setProfileImageUrl(request.getProfileImageUrl());
//        userProfile.setIntroduction(request.getIntroduction());
//        userProfile.setLocation(request.getLocation());
//        userProfile.setWebsite(request.getWebsite());
//
//        return userProfileRepository.save(userProfile);
//    }
//
//    public void updateProfileImage(Long userId, String imageUrl) {
//        UserProfile userProfile = getUserProfile(userId);
//        userProfile.setProfileImageUrl(imageUrl);
//        userProfileRepository.save(userProfile);
//    }
}