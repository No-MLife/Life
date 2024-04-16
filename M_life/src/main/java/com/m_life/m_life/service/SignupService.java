package com.m_life.m_life.service;

import com.m_life.m_life.domain.UserAccount;
import com.m_life.m_life.dto.request.SignupRequest;
import com.m_life.m_life.repository.UserAccountRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class SignupService {

    private final UserAccountRepository userRepository;
    private final BCryptPasswordEncoder bCryptPasswordEncoder;


    public String joinProcess(SignupRequest signupRequest) {

        String userid = signupRequest.getUsername();
        String nickname = signupRequest.getNickname();
        String password = signupRequest.getPassword();

        Boolean isExist = userRepository.existsByUserid(userid);

        if (isExist) {

            return "이미 존재하는 회원 아이디입니다.";
        }

        UserAccount userAccount = UserAccount.of(
                nickname,
                userid,
                bCryptPasswordEncoder.encode(password),
                "ROLE_ADMIN"
        );
        userRepository.save(userAccount);
        return "회원가입 되었습니다.";
    }
}