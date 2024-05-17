package com.m_life.m_life.service;

import com.m_life.m_life.domain.UserAccount;
import com.m_life.m_life.domain.UserProfile;
import com.m_life.m_life.dto.Experience;
import com.m_life.m_life.dto.request.SignupRequest;
import com.m_life.m_life.repository.UserAccountRepository;
import com.m_life.m_life.repository.UserProfileRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class MyUserService {

    private final UserAccountRepository userRepository;
    private final BCryptPasswordEncoder bCryptPasswordEncoder;
    private final UserProfileRepository userProfileRepository;


    public ResponseEntity<String> joinProcess(SignupRequest signupRequest) {

        String userid = signupRequest.getUsername();
        String nickname = signupRequest.getNickname();
        String password = signupRequest.getPassword();

        Boolean isExist = userRepository.existsByUserid(userid);

        if (isExist) {
            return ResponseEntity.badRequest().body("이미 존재하는 회원 아이디입니다.");
        }
        boolean isExistNick = userRepository.existsByNickname(nickname);
        if(isExistNick){
            return ResponseEntity.badRequest().body("이미 존재하는 회원 닉네임입니다.");
        }


        UserAccount userAccount = UserAccount.of(
                nickname,
                userid,
                bCryptPasswordEncoder.encode(password),
                "ROLE_USER"
        );
        userRepository.save(userAccount);

        // 회원 가입 시 프로필을 추가
        UserProfile userProfile = UserProfile.of(
                "https://mlifeapp.s3.ap-northeast-2.amazonaws.com/profile-images/63169b9f-9d5a-4473-969e-76904263a0dd_copy_logo+%E1%84%87%E1%85%A9%E1%86%A8%E1%84%89%E1%85%A1%E1%84%87%E1%85%A9%E1%86%AB.png",
                "한 줄 자기소개","", Experience.ZERO_YEAR, userAccount
        );
        userProfileRepository.save(userProfile);

        return ResponseEntity.ok().body("회원가입 되었습니다.");
    }

}