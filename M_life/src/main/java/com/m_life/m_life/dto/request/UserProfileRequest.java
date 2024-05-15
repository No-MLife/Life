package com.m_life.m_life.dto.request;


public record UserProfileRequest(
        long id,
        String profileImageUrl,
        String introduction,
        String jobName,
        int experience
) {
    public static UserProfileRequest of(long id, String profileImageUrl, String introduction, String jobName,
                                        int experience){
        return new UserProfileRequest(id, profileImageUrl, introduction, jobName, experience);
    }
}
