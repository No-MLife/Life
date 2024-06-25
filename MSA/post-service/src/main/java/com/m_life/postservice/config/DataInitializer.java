package com.m_life.postservice.config;

import com.m_life.postservice.domain.Post;
import com.m_life.postservice.dto.req.PostRequest;
import com.m_life.postservice.repository.PostRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

@Component
public class DataInitializer implements CommandLineRunner {

    private final PostRepository postRepository;




    public DataInitializer(PostRepository postRepository) {
        this.postRepository = postRepository;
    }

    @Override
    public void run(String... args) throws Exception {
            // 게시글
            List<Post> posts = new ArrayList<>();
            for (int i = 1; i <= 100; i++) {
                PostRequest postRequest = new PostRequest();
                postRequest.setTitle("title" + i);
                postRequest.setContent("content" + i);
                Post post = Post.of(postRequest, 2L, 1L);
                posts.add(post);
            }
            postRepository.saveAll(posts);

        }


}