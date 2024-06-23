package com.m_life.userservice.servcie;


import com.m_life.userservice.domain.UserAccount;
import com.m_life.userservice.repository.UserAccountRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
@Slf4j
@RequiredArgsConstructor
public class CustomUserDetailsService implements UserDetailsService {

    private final UserAccountRepository userRepository;

    @Override
    public UserDetails loadUserByUsername(String userLoginId) throws UsernameNotFoundException {
        //DB에서 조회
        UserAccount userData = userRepository.findByUserLoginId(userLoginId);

        if (userData == null) {
            throw new UsernameNotFoundException("사용자를 찾을 수 없습니다.");
        }

        //UserDetails를 구현한 클래스에 UserAccount 객체를 포함하여 반환
        return new CustomUserDetails(userData);
    }
}