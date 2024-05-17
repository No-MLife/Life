package com.m_life.m_life.controller;

import com.m_life.m_life.domain.UserProfile;
import com.m_life.m_life.dto.request.UserProfileRequest;
import com.m_life.m_life.dto.response.UserProfileResponse;
import com.m_life.m_life.service.S3Service;
import com.m_life.m_life.service.UserProfileService;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/users")
public class UserController {
    private final UserProfileService userProfileService;
    Logger logger = LoggerFactory.getLogger(UserController.class);

    @GetMapping("/profile/{nickname}")
    public UserProfileResponse getUserProfile(@PathVariable(name = "nickname") String nickname) {
        return userProfileService.getUserProfile(nickname);
    }

    @PutMapping("/profile/{nickname}")
    public ResponseEntity<String> updateUserProfile(
            @PathVariable(name = "nickname") String nickname, @RequestBody UserProfileRequest userProfileRequest) {
        return userProfileService.updateUserProfile(nickname, userProfileRequest);
    }


    @PutMapping("/profile/{nickname}/image")
    public ResponseEntity<String> uploadProfileImage(
            @PathVariable(name = "nickname") String nickName,
            @RequestParam("image") MultipartFile file
    ) {
        userProfileService.uploadProfileImage(nickName, file);
        return ResponseEntity.ok("프로필 이미지가 성공적으로 업로드되었습니다.");
    }


//    @PostMapping("/profile")
//    public ResponseEntity<String> createUserProfile(@RequestBody UserProfileRequest userProfileRequest) {
//
//    }




}
