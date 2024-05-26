package com.m_life.m_life.dto.request;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class SignupRequest {

    private String username;
    private String password;
    private String nickname;
    private String email;
}