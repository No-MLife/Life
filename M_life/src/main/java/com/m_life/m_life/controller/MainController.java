package com.m_life.m_life.controller;

import com.m_life.m_life.dto.request.SignupRequest;
import com.m_life.m_life.service.SignupService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
public class MainController {
    private final SignupService signupService;
    @GetMapping(value = "/")
    public String get_main(){
        return "hello world";
    }

    @PostMapping("/signup")
    public ResponseEntity<String> signup(@RequestBody SignupRequest signupRequest) {
        return signupService.joinProcess(signupRequest);
    }

}
