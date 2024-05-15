package com.m_life.m_life.dto.response;


import com.m_life.m_life.domain.UserProfile;

public record UserProfileResponse(
        long id,
        String profileImageUrl,
        String introduction,
        String jobName,
        int experience

) {
    public static UserProfileResponse of(Long id, String profileImageUrl, String introduction, String jobName, int experience) {
        return new UserProfileResponse(id, profileImageUrl, introduction, jobName, experience);
    }

    public static UserProfileResponse from(UserProfile userProfile) {

        return new UserProfileResponse(
                userProfile.getId(),
                userProfile.getProfileImageUrl(),
                userProfile.getIntroduction(),
                userProfile.getJobName(),
                userProfile.getExperience()
        );
    }
}