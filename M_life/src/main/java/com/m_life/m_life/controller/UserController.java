package com.m_life.m_life.controller;

import com.m_life.m_life.domain.UserProfile;
import com.m_life.m_life.dto.request.UserProfileRequest;
import com.m_life.m_life.dto.response.UserProfileResponse;
import com.m_life.m_life.service.S3Service;
import com.m_life.m_life.service.UserProfileService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/users")
public class UserController {
    private final UserProfileService userProfileService;

    @GetMapping("/profile/{nick_name}")
    public UserProfileResponse getUserProfile(@PathVariable(name = "nick_name") String nick_name) {
        return userProfileService.getUserProfile(nick_name);
    }


//    @PostMapping("/profile")
//    public ResponseEntity<String> createUserProfile(@RequestBody UserProfileRequest userProfileRequest) {
//
//    }




}
