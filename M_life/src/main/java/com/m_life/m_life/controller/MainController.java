package com.m_life.m_life.controller;

import com.m_life.m_life.dto.request.SignupRequest;
import com.m_life.m_life.service.SignupService;
import lombok.RequiredArgsConstructor;
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

    @PostMapping(value = "/")
    public String po(){
        return "hello world";
    }

    @PostMapping("/signup")
    public String signup(@RequestBody SignupRequest signupRequest) {

        System.out.println(signupRequest.getUsername());
        return signupService.joinProcess(signupRequest);
    }

}
