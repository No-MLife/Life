package com.m_life.m_life.controller;

import com.m_life.m_life.dto.request.PostRequest;
import com.m_life.m_life.dto.response.PostResponse;
import com.m_life.m_life.service.PostService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/")
public class PostController {

    private final PostService postService;
    @PostMapping("/post")
    public ResponseEntity<String> createPost(@RequestBody PostRequest postRequest){
        return postService.save(postRequest);
    }

    @PutMapping("/post/{postid}")
    public ResponseEntity<String> updatePost(@RequestBody PostRequest postRequest, @PathVariable(name = "postid") Integer id){
        return postService.update(postRequest, id);
    }

    @DeleteMapping("/post/{postid}")
    public ResponseEntity<String> deletePost(@PathVariable(name= "postid") Integer id){
        return postService.delete(id);
    }

    @GetMapping("/post")
    public List<PostResponse> getPosts(){
        return postService.getAllposts();
    }

    @GetMapping("/post/{postid}")
    public PostResponse getPost(@PathVariable(name = "postid") Integer id){
        return postService.getMypost(id);
    }
}
