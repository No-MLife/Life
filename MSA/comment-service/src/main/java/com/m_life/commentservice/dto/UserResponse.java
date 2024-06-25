package com.m_life.commentservice.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
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
    // 기본 생성자
    public UserResponse() {
    }

}
