package com.m_life.m_life.controller;

import com.m_life.m_life.domain.PostCategory;
import com.m_life.m_life.dto.request.SignupRequest;
import com.m_life.m_life.repository.PostCategoryRepository;
import com.m_life.m_life.service.MyUserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
public class MainController {
    private final MyUserService myUserService;
    private final PostCategoryRepository postCategoryRepository;

    @GetMapping(value = "/")
    public String get_main(){
        return "hello world";
    }

    @PostMapping("/signup")
    public ResponseEntity<String> signup(@RequestBody SignupRequest signupRequest) {
        return myUserService.joinProcess(signupRequest);
    }

    @GetMapping("/category/{categoryId}")
    public ResponseEntity<String> getCategoryName(@PathVariable(name = "categoryId") Long categoryId) {
        PostCategory postCategory = postCategoryRepository.findById(categoryId).orElseThrow(
                () -> new IllegalArgumentException("There is no Category")
        );
        return ResponseEntity.ok().body(postCategory.getDescription());
    }

    @DeleteMapping("/{nickname}")
    public ResponseEntity<Void> deleteUser(@PathVariable(name="nickname") String nickname) {
        try {
            myUserService.deleteUser(nickname);
            return ResponseEntity.noContent().build();
        } catch (IllegalArgumentException e) {
            return ResponseEntity.notFound().build();
        }
    }



}
