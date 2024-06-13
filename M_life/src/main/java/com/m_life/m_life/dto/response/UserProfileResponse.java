package com.m_life.m_life.dto.response;


import com.m_life.m_life.domain.UserProfile;
import com.m_life.m_life.dto.Experience;

public record UserProfileResponse(
        long id,
        String profileImageUrl,
        String introduction,
        String jobName,
        Experience experience,
        Long totalLikes


) {
    public static UserProfileResponse of(Long id, String profileImageUrl, String introduction, String jobName, Experience experience, Long totalLikes) {
        return new UserProfileResponse(id, profileImageUrl, introduction, jobName, experience, totalLikes);
    }

    public static UserProfileResponse from(UserProfile userProfile, Long totalLikes) {

        return new UserProfileResponse(
                userProfile.getId(),
                userProfile.getProfileImageUrl(),
                userProfile.getIntroduction(),
                userProfile.getJobName(),
                userProfile.getExperience(),
                totalLikes
        );
    }
}