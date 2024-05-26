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
        String email = signupRequest.getEmail();

        Boolean isExist = userRepository.existsByUserid(userid);
        if (isExist) {
            return ResponseEntity.badRequest().body("이미 존재하는 회원 아이디입니다.");
        }

        boolean isExistNick = userRepository.existsByNickname(nickname);
        if(isExistNick){
            return ResponseEntity.badRequest().body("이미 존재하는 회원 닉네임입니다.");
        }

        boolean isExistEmail = userRepository.existsByEmail(email);
        if(isExistEmail){
            return ResponseEntity.badRequest().body("이미 존재하는 회원 이메일입니다.");
        }


        UserAccount userAccount = UserAccount.of(
                nickname,
                userid,
                bCryptPasswordEncoder.encode(password),
                email,
                "ROLE_USER"
        );
        userRepository.save(userAccount);

        // 회원 가입 시 프로필을 추가
        UserProfile userProfile = UserProfile.of(
                "",
                "한 줄 자기소개","", Experience.ZERO_YEAR, userAccount
        );
        userProfileRepository.save(userProfile);

        return ResponseEntity.ok().body("회원가입 되었습니다.");
    }

}