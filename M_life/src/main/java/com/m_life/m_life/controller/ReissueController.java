package com.m_life.m_life.controller;

import com.m_life.m_life.jwt.JWTUtil;
import com.m_life.m_life.service.ReissueService;
import io.jsonwebtoken.ExpiredJwtException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;


@RestController
@RequiredArgsConstructor
public class ReissueController {

    private final JWTUtil jwtUtil;
    private final ReissueService reissueService;
    Logger logger = LoggerFactory.getLogger(ReissueController.class);

    @PostMapping("/reissue")
    public ResponseEntity<?> reissue(HttpServletRequest request, HttpServletResponse response) {
        // request 요청 받음  response 요청 보냄
        logger.info("리프레쉬을 이용해서 토큰 재발급 요청중....");
        Cookie[] cookies = request.getCookies();
        return reissueService.reissue(cookies, response);
    }
}