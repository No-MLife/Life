package com.m_life.postservice.client;

import com.m_life.postservice.dto.res.UserResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@FeignClient(name = "user-service")
public interface UserServiceClient {

    @GetMapping("/users/{userId}")
    UserResponse getUserByUserId(@PathVariable(name = "userId") Long userID);

}
