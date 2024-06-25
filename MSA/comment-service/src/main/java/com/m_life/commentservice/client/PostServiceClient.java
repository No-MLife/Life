package com.m_life.commentservice.client;

import com.m_life.commentservice.dto.PostResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@FeignClient(name = "post-service")
public interface PostServiceClient {
    @GetMapping(value = "/post-service/posts/{postId}")
    PostResponse getPostById(@PathVariable(name = "postId")Long postId);

}
