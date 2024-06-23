package com.m_life.userservice.controller;
import com.m_life.userservice.dto.SignupRequest;
import com.m_life.userservice.dto.UserProfileRequest;
import com.m_life.userservice.dto.UserProfileResponse;
import com.m_life.userservice.dto.UserResponse;
import com.m_life.userservice.servcie.UserAccountService;

import com.m_life.userservice.servcie.UserProfileService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@RestController
@RequiredArgsConstructor
public class UserController {

    private final UserAccountService userAccountService;
    private final UserProfileService userProfileService;

    // ====================================================== GET =====================================================

    @GetMapping("/")
    public String status() {
        return "It's Working in User Micro Service";
    }

    //  User id로 조회[GET]
    @GetMapping("/users/{userId}")
    public ResponseEntity<UserResponse> getUser(@PathVariable(name = "userId") Long userId) {
        return userAccountService.getUser(userId);
    }

    //  전체 User 조회[GET]
    @GetMapping("/users")
    public ResponseEntity<List<UserResponse>> getUsers() {
        return userAccountService.getUsers();
    }

    // 유저 닉네임으로 프로필 조회[GET]
    @GetMapping("/profile/{nickname}")
    public UserProfileResponse getUserProfile(@PathVariable(name = "nickname") String nickname) {
        return userProfileService.getUserProfile(nickname);
    }
    // ====================================================== GET =====================================================

    // ====================================================== POST =====================================================
    @PostMapping("/signup")
    public ResponseEntity<String> signup(@RequestBody SignupRequest signupRequest) {
        return userAccountService.joinProcess(signupRequest);
    }
    // ====================================================== POST =====================================================



    // ====================================================== PUT =====================================================
    // 유저 닉네임으로 프로필 정보 변경[PUT]
    @PutMapping("/profile/{nickname}")
    public ResponseEntity<String> updateUserProfile(
            @PathVariable(name = "nickname") String nickname, @RequestBody UserProfileRequest userProfileRequest) {
        return userProfileService.updateUserProfile(nickname, userProfileRequest);
    }
    // 유저 닉네임으로 프로필 이미지 변경[PUT]
    @PutMapping("/profile/{nickname}/image")
    public ResponseEntity<String> uploadProfileImage(
            @PathVariable(name = "nickname") String nickName,
            @RequestParam("image") MultipartFile file
    ) {
        userProfileService.uploadProfileImage(nickName, file);
        return ResponseEntity.ok("프로필 이미지가 성공적으로 업로드되었습니다.");
    }
    // ====================================================== PUT =====================================================





    // ====================================================== DELETE =====================================================
    @DeleteMapping("/{nickname}")
    public ResponseEntity<Void> deleteUser(@PathVariable(name="nickname") String nickname) {
        try {
            userAccountService.deleteUser(nickname);
            return ResponseEntity.noContent().build();
        } catch (IllegalArgumentException e) {
            return ResponseEntity.notFound().build();
        }
    }

    // ====================================================== DELETE =====================================================


}