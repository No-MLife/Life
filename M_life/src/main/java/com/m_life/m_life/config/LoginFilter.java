package com.m_life.m_life.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.m_life.m_life.domain.RefreshEntity;
import com.m_life.m_life.jwt.JWTUtil;
import com.m_life.m_life.repository.RefreshRepository;
import com.m_life.m_life.service.CustomUserDetails;
import jakarta.servlet.FilterChain;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import java.io.BufferedReader;
import java.io.IOException;
import java.util.Collection;
import java.util.Date;
import java.util.Iterator;

@RequiredArgsConstructor
public class LoginFilter extends UsernamePasswordAuthenticationFilter {

    private final AuthenticationManager authenticationManager;
    private final JWTUtil jwtUtil;
    private final RefreshRepository refreshRepository;
    private final Logger logger = LoggerFactory.getLogger(LoginFilter.class);
    
    @Override
    public Authentication attemptAuthentication(HttpServletRequest request, HttpServletResponse response) throws AuthenticationException {
        try {
            // HttpServletRequest에서 JSON 데이터를 읽음
            BufferedReader reader = request.getReader();
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }

            // ObjectMapper를 사용하여 JSON 데이터를 Java 객체로 변환
            ObjectMapper mapper = new ObjectMapper();
            LoginRequest loginRequest = mapper.readValue(sb.toString(), LoginRequest.class);

            // LoginRequest 객체에서 username과 password를 추출
            String username = loginRequest.getUsername();
            String password = loginRequest.getPassword();


            //스프링 시큐리티에서 username과 password를 검증하기 위해서는 token에 담아야 함
            UsernamePasswordAuthenticationToken authToken = new UsernamePasswordAuthenticationToken(username, password, null);

            //token에 담은 검증을 위한 AuthenticationManager로 전달
            return authenticationManager.authenticate(authToken);
        } catch (IOException  e) {
            throw new AuthenticationException("JSON 파싱 실패", e) {};
        }
    }

    @Override
    protected void successfulAuthentication(HttpServletRequest request, HttpServletResponse response, FilterChain chain, Authentication authentication) {

        CustomUserDetails customUserDetails = (CustomUserDetails) authentication.getPrincipal();

        String username = customUserDetails.getUsername();
        String nickname = customUserDetails.getUserAccount().getNickname();

        Collection<? extends GrantedAuthority> authorities = authentication.getAuthorities();
        Iterator<? extends GrantedAuthority> iterator = authorities.iterator();
        GrantedAuthority auth = iterator.next();

        String role = auth.getAuthority();

        //토큰 생성
        String access = jwtUtil.createJwt("access", username,nickname, role, 600000L);
        String refresh = jwtUtil.createJwt("refresh", username, nickname, role, 86400000L);

        //Refresh 토큰 저장
        addRefreshEntity(username, refresh, 86400000L);

        //응답 설정
        response.setHeader("access", access); // 헤더에 접근 토큰 
        response.addCookie(createCookie("refresh", refresh)); // 쿠키에 리프레쉬 토큰
        response.setStatus(HttpStatus.OK.value());

        logger.info("로그인을 성공했습니다.");
    }

    private void addRefreshEntity(String username, String refresh, Long expiredMs) {

        Date date = new Date(System.currentTimeMillis() + expiredMs);

        RefreshEntity refreshEntity = new RefreshEntity();
        refreshEntity.setUsername(username);
        refreshEntity.setRefresh(refresh);
        refreshEntity.setExpiration(date.toString());

        refreshRepository.save(refreshEntity);
    }

    @Override
    protected void unsuccessfulAuthentication(HttpServletRequest request, HttpServletResponse response, AuthenticationException failed) {

        logger.info("로그인을 실패했습니다.");
        response.setStatus(401);
    }

    private static class LoginRequest {
        // getter와 setter는 Lombok의 @Data 어노테이션을 사용하여 자동 생성 가능
        @Getter
        private String username;
        @Getter
        private String password;
        private String nickname;

    }
    private Cookie createCookie(String key, String value) {

        Cookie cookie = new Cookie(key, value);
        cookie.setMaxAge(24*60*60);
        //cookie.setSecure(true); // https 에서 사용
        //cookie.setPath("/");
        cookie.setHttpOnly(true);

        return cookie;
    }
}
