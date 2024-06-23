package com.m_life.userservice.dto;


import com.fasterxml.jackson.annotation.JsonInclude;
import com.m_life.userservice.domain.UserAccount;
import lombok.Data;

@Data
@JsonInclude(JsonInclude.Include.NON_NULL)
public class UserResponse {
    private Long id;
    private String userLoginId; // 로그인 아이디
    private String email;
    private String nickname;

    private UserResponse(Long id, String userLoginId, String email, String nickname){
        this.id = id;
        this.userLoginId = userLoginId;
        this.email = email;
        this.nickname = nickname;
    }

    public static UserResponse from(UserAccount userAccount){
        return new UserResponse(
                userAccount.getId(),
                userAccount.getUserLoginId(),
                userAccount.getEmail(),
                userAccount.getNickname()
        );
    }

}
