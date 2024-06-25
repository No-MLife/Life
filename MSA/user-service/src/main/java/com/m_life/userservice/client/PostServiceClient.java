package com.m_life.userservice.client;

import com.m_life.userservice.dto.PostResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import java.util.List;

@FeignClient(name="post-service")
public interface PostServiceClient {
    // public으로 명시하지 않아도 모두 public

    @GetMapping("/post-service/users/{userId}/posts")
    List<PostResponse> getPosts(@PathVariable(name = "userId") Long userId);
}
