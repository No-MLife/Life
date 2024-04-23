package com.m_life.m_life.service;

import com.m_life.m_life.domain.Post;
import com.m_life.m_life.domain.PostLike;
import com.m_life.m_life.domain.UserAccount;
import com.m_life.m_life.repository.PostLikeRepository;
import com.m_life.m_life.repository.PostRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service
@Transactional
@RequiredArgsConstructor
@Slf4j
public class PostLikeService {
    private final PostRepository postRepository;
    private final PostLikeRepository postLikeRepository;
    private final Logger logger = LoggerFactory.getLogger(PostLikeService.class);

    public void likePost(Long postId, UserAccount userAccount) {
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new IllegalArgumentException("Invalid post ID"));

        if (isAlreadyLiked(post, userAccount)) {
            throw new IllegalStateException("이미 좋아요한 게시물입니다.");
        }

        PostLike postLike = new PostLike();
        postLike.setPost(post);
        postLike.setUserAccount(userAccount);
        postLikeRepository.save(postLike);
    }

    public void unlikePost(Long postId, UserAccount userAccount) {
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new IllegalArgumentException("Invalid post ID"));

        PostLike postLike = postLikeRepository.findByPostAndUserAccount(post, userAccount);
        if(postLike != null){
            postLikeRepository.delete(postLike);
        }
        else{
            logger.info("좋아요한 기록이 없습니다.");
        }
    }

    private boolean isAlreadyLiked(Post post, UserAccount userAccount) {
        return postLikeRepository.existsByPostAndUserAccount(post, userAccount);
    }

    public long getLikeCount(Long postId) {
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new IllegalArgumentException("Invalid post ID"));
        return post.getLikes().size();
    }

    public boolean isLikedByUser(Long postId, UserAccount userAccount) {
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new IllegalArgumentException("Invalid post ID"));
        return post.getLikes().stream()
                .anyMatch(like -> like.getUserAccount().equals(userAccount));
    }
}
