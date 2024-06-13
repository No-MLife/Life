package com.m_life.m_life.service;

import com.m_life.m_life.domain.UserAccount;
import com.m_life.m_life.domain.UserProfile;
import com.m_life.m_life.dto.request.UserProfileRequest;
import com.m_life.m_life.dto.response.UserProfileResponse;
import com.m_life.m_life.repository.UserAccountRepository;
import com.m_life.m_life.repository.UserProfileRepository;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

@Service
@Transactional
@RequiredArgsConstructor
public class UserProfileService {
    private final UserProfileRepository userProfileRepository;
    private final UserAccountRepository userAccountRepository;
    private final S3Service s3Service;
    private Logger logger = LoggerFactory.getLogger(UserProfileService.class);


    @Transactional(readOnly = true)
    public UserProfileResponse getUserProfile(String nick_name) {
        // step1. 유저에 대한 정보를 가져온 후 닉네임에 맞게 재탐색
        UserAccount userAccount = userAccountRepository.findByNickname(nick_name);

        // step2. 해당 유저가 존재한다면 다음으로 진행
        if(userProfileRepository.existsByUserAccount(userAccount)){
            Long totalLikes = userAccountRepository.getTotalLikeCountByNickname(nick_name);
            UserProfile userProfile = userProfileRepository.findByUserAccount(userAccount);
            return UserProfileResponse.from(userProfile, totalLikes);
        }
        else{
            return null;
        }
    }

    public ResponseEntity<String> updateUserProfile(String nick_name, UserProfileRequest request) {
        UserAccount userAccount = userAccountRepository.findByNickname(nick_name);
        if(userProfileRepository.existsByUserAccount(userAccount)){
            UserProfile userProfile = userProfileRepository.findByUserAccount(userAccount);
            userProfile.setIntroduction(request.introduction());
            userProfile.setExperience(request.experience());
            userProfile.setJobName(request.jobName());
            userProfileRepository.save(userProfile);
            return ResponseEntity.ok().body("프로필을 성공적으로 수정했습니다.");
        }
        return ResponseEntity.badRequest().body("프로필 수정에 실패하였습니다.");

    }


    public void uploadProfileImage(String nickName, MultipartFile file) {
        UserAccount userAccount = userAccountRepository.findByNickname(nickName);
        if (userAccount != null) {
            UserProfile userProfile = userProfileRepository.findByUserAccount(userAccount);
            if (userProfile != null) {
                String imageUrl = s3Service.uploadProfileImage(file);
                userProfile.setProfileImageUrl(imageUrl);
                userProfileRepository.save(userProfile);
            }
        }
    }

    public ResponseEntity<Long> getTotalLikeCountByNickname(String nickname) {
        return ResponseEntity.ok().body(userAccountRepository.getTotalLikeCountByNickname(nickname));
    }
}