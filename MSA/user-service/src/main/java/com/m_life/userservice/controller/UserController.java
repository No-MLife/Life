package com.m_life.userservice.controller;

import com.m_life.userservice.dto.req.SignupRequest;
import com.m_life.userservice.service.UserAccountService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
public class UserController {
    @Value("${greeting.message}")
    private String message;

    private final UserAccountService userAccountService;

    // 서버가 실행중인지 확인
    @GetMapping("/health_check")
    public String status() {
        return "It's Working in User Micro Service";
    }
    // 웰컴 메시지
    @GetMapping("/welcome")
    public String welcome() {
        return message;
    }

    @PostMapping("/signup")
    public ResponseEntity<String> signup(@RequestBody SignupRequest signupRequest) {
        return userAccountService.joinProcess(signupRequest);
    }
}
