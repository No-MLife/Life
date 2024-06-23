package com.m_life.userservice.controller;
import com.m_life.userservice.dto.SignupRequest;
import com.m_life.userservice.dto.UserResponse;
import com.m_life.userservice.servcie.UserAccountService;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/user-service")
public class UserController {

    private final UserAccountService userAccountService;

    // 서버가 실행중인지 확인
    @GetMapping("/")
    public String status() {
        return "It's Working in User Micro Service";
    }

    @GetMapping("/users/{userId}")
    public ResponseEntity<UserResponse> getUser(@PathVariable(name = "userId") Long userId) {
        return userAccountService.getUser(userId);
    }

    @PostMapping("/signup")
    public ResponseEntity<String> signup(@RequestBody SignupRequest signupRequest) {
        return userAccountService.joinProcess(signupRequest);
    }
}