package com.m_life.postservice.dto.res;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.m_life.postservice.domain.Post;
import com.m_life.postservice.domain.PostImage;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

@Data
@JsonInclude(JsonInclude.Include.NON_NULL)
public class PostResponse {
    private Long id;
    private String title;
    private String content;
    private LocalDateTime createAt;

    private int view_count;
    // 댓글 리스트
    private List<CommentResponse> commentList = new ArrayList<>();
    private int likeCount;
    private String authorName;


    // 카테고리
    private String boardName;
    private String description;
    private Long categoryId;

    private Long authorLikes;
    private List<String> images = new ArrayList<>();

    public static PostResponse fromPost(Post post) {
        List<String> imageUrls = post.getImages().stream()
                .map(PostImage::getS3Url)
                .toList();

        PostResponse responsePost = new PostResponse();
        responsePost.setId(post.getId());
        responsePost.setTitle(post.getTitle());
        responsePost.setContent(post.getContent());
        responsePost.setCreateAt(post.getCreateDate());
        responsePost.setLikeCount(post.getLikes().size());
        responsePost.setCategoryId(responsePost.getCategoryId());
        responsePost.setImages(imageUrls);
        return responsePost;
    }
}
