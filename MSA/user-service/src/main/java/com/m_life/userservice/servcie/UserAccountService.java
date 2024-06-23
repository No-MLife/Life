package com.m_life.userservice.servcie;


import com.m_life.userservice.dto.Experience;
import com.m_life.userservice.dto.SignupRequest;
import com.m_life.userservice.dto.UserResponse;
import com.m_life.userservice.repository.UserProfileRepository;
import com.m_life.userservice.domain.UserAccount;
import com.m_life.userservice.domain.UserProfile;
import com.m_life.userservice.repository.UserAccountRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

@Service
@RequiredArgsConstructor
public class UserAccountService {

    private final UserAccountRepository userRepository;
    private final BCryptPasswordEncoder bCryptPasswordEncoder;
    private final UserProfileRepository userProfileRepository;



    public ResponseEntity<String> joinProcess(SignupRequest signupRequest) {

        String userid = signupRequest.getUserLoginId();
        String nickname = signupRequest.getNickname();
        String password = signupRequest.getPassword();
        String email = signupRequest.getEmail();

        Boolean isExist = userRepository.existsByUserLoginId(userid);
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

    public void deleteUser(String nickname) {
        if (userRepository.existsByNickname(nickname)) {
            Long userId = userRepository.findByNickname(nickname).getId();
            userRepository.deleteById(userId);
        } else {
            throw new IllegalArgumentException("User not found with nickname: " + nickname);
        }
    }


    public ResponseEntity<UserResponse> getUser(Long userId) {
        UserAccount userAccount = userRepository.findById(userId).orElseThrow(
                () -> new ResponseStatusException(HttpStatus.NOT_FOUND, "해당 유저가 존재하지 않습니다.")
        );
        return ResponseEntity.ok().body(UserResponse.from(userAccount));
    }
}