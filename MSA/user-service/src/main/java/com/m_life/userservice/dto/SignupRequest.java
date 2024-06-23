package com.m_life.userservice.dto;

import lombok.Data;

@Data
public class SignupRequest {

    private String userLoginId;
    private String password;
    private String nickname;
    private String email;
}