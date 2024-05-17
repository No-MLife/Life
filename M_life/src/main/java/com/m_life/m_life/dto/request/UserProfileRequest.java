package com.m_life.m_life.dto.request;
import com.m_life.m_life.dto.Experience;

public record UserProfileRequest(
        long id,
        String profileImageUrl,
        String introduction,
        String jobName,
        Experience experience
) {
    public static UserProfileRequest of(long id, String profileImageUrl, String introduction, String jobName,
                                        Experience experience){
        return new UserProfileRequest(id, profileImageUrl, introduction, jobName, experience);
    }
}