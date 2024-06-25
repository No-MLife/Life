package com.m_life.postservice.servcie;

import com.m_life.postservice.client.UserServiceClient;
import com.m_life.postservice.domain.Post;
import com.m_life.postservice.domain.PostLike;
import com.m_life.postservice.dto.res.UserResponse;
import com.m_life.postservice.repository.PostLikeRepository;
import com.m_life.postservice.repository.PostRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

@Service
@RequiredArgsConstructor
@Slf4j
public class PostLikeService {
    private final PostRepository postRepository;
    private final PostLikeRepository postLikeRepository;
    protected final UserServiceClient userServiceClient;


    // 해당 유저가 특정 게시글을 좋아요 했는지 여부 확인 [READ]
    @Transactional(readOnly = true)
    public boolean isLikedByUser(Long userId, Long postId) {
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND));
        UserResponse userResponse = userServiceClient.getUserByUserId(userId); // 여기서 해당 유저가 존재하는지 확인하는 로직을 추가할것인가....

        // post ID + userId로 좋아요를 했는지 확인
        return postLikeRepository.existsByPostAndUserId(post, userId);
    }

    // 해당 유저가 특정 게시글을 좋아요 [CREATE]
    @Transactional
    public void likePost(Long userId, Long postId) {
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND));

        UserResponse userResponse = userServiceClient.getUserByUserId(userId); // 여기서 해당 유저가 존재하는지 확인하는 로직을 추가할것인가....

        if (isAlreadyLiked(userId, post)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "이미 좋아요한 게시물입니다.");
        }

        PostLike postLike = new PostLike();
        postLike.setPost(post);
        postLike.setUserId(userId);
        postLikeRepository.save(postLike);

        // Redis Sorted Set 업데이트
//        updatePostLikes(postId, 1);
    }

    // 해당 유저가 특정 게시글 좋아요를 취소 [DELETE]
    public ResponseEntity<String> unlikePost(Long userId, Long postId) {
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND));

        if (isAlreadyLiked(userId, post)) {
            PostLike postLike = postLikeRepository.findByPostAndUserId(post, userId);
            postLikeRepository.delete(postLike);
            return ResponseEntity.status(HttpStatus.NO_CONTENT).body(null);
        }
        else{
            log.info("좋아요한 기록이 없습니다.");
            return ResponseEntity.badRequest().body("좋아요한 기록이 없습니다.");
        }

//        updatePostLikes(postId, -1);
    }
//

//
//    public long getLikeCount(Long postId) {
//        Post post = postRepository.findById(postId)
//                .orElseThrow(() -> new IllegalArgumentException("Invalid post ID"));
//        return post.getLikes().size();
//    }
//
//
//
//
//    private void updatePostLikes(Long postId, int delta) {
//        // ZSet에서 점수(좋아요 수) 업데이트
//        myredisTemplate.opsForZSet().incrementScore(POPULAR_POSTS_KEY, postId.toString(), delta);
//
//        // 해당 포스트가 Redis 해시에 존재하는지 확인하고, 존재하면 업데이트
//        PostResponse postResponse = postRedisTemplateService.getPostFromCache(postId.toString());
//        if (postResponse != null) {
//            // 좋아요 수 갱신
//            Post post = postRepository.findById(postId).orElse(null);
//            if (post != null) {
//                postResponse = PostResponse.from(post, userAccountRepository);
//                postRedisTemplateService.save(postResponse);
//            }
//        }
//        logger.info("좋아요 수 변경: PostId = {}, Delta = {}", postId, delta);
//    }

    private boolean isAlreadyLiked(Long userId, Post post) {
        return postLikeRepository.existsByPostAndUserId(post, userId);
    }
}
