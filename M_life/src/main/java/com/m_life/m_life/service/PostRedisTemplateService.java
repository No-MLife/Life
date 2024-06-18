package com.m_life.m_life.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.m_life.m_life.dto.response.PostResponse;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.redis.core.HashOperations;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
@RequiredArgsConstructor
public class PostRedisTemplateService {
    private static final String POST_CACHE_KEY = "postCache";
    private static final Logger logger = LoggerFactory.getLogger(PostRedisTemplateService.class);

    private final RedisTemplate<String, Object> redisTemplate;
    private final ObjectMapper objectMapper;
    private HashOperations<String, String, String> hashOperations;

    @PostConstruct
    public void init() {
        this.hashOperations = redisTemplate.opsForHash();
    }

    public void save(PostResponse postResponse) {
        if (Objects.isNull(postResponse) || Objects.isNull(postResponse.id())) {
            return;
        }

        try {
            hashOperations.put(POST_CACHE_KEY,
                    postResponse.id().toString(),
                    serializePostDto(postResponse));
            logger.info("성공적으로 저장되었습니다 {}: {}", POST_CACHE_KEY, postResponse.id());
        } catch (Exception e) {
            logger.error("에러 발생: {}", e.getMessage());
        }
    }

    public PostResponse getPostFromCache(String postId) {
        try {
            String value = hashOperations.get(POST_CACHE_KEY, postId);
            if (value != null) {
                return deserializePostDto(value);
            }
            return null;
        } catch (Exception e) {
            logger.error("에러 발생: {}", e.getMessage());
            return null;
        }
    }

    public List<PostResponse> findAll() {
        try {
            List<PostResponse> list = new ArrayList<>();
            for (String value : hashOperations.entries(POST_CACHE_KEY).values()) {
                PostResponse postResponse = deserializePostDto(value);
                list.add(postResponse);
            }
            return list;
        } catch (Exception e) {
            logger.error("에러 발생: {}", e.getMessage());
            return Collections.emptyList();
        }
    }

    public void delete(String postId) {
        try {
            hashOperations.delete(POST_CACHE_KEY, postId);
            logger.info("성공적으로 삭제되었습니다 {}: {}", POST_CACHE_KEY, postId);
        } catch (Exception e) {
            logger.error("에러 발생: {}", e.getMessage());
        }
    }

    private String serializePostDto(PostResponse postResponse) throws JsonProcessingException {
        return objectMapper.writeValueAsString(postResponse);
    }

    private PostResponse deserializePostDto(String value) throws JsonProcessingException {
        return objectMapper.readValue(value, PostResponse.class);
    }
}
