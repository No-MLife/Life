package com.m_life.postservice.domain;

import com.m_life.postservice.dto.PostRequest;
import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;


@Data
@NoArgsConstructor
@Table(name = "post")
@Entity
public class Post extends BaseTimeEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Setter
    @Column(nullable = false)
    private String title;

    @Setter
    @Column(nullable = false, length = 10000)
    private String content;
//
//    @Setter
//    @Column(nullable = false)
//    private int view_count;

    @OneToMany(mappedBy = "post", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<PostImage> images = new ArrayList<>();

    @OneToMany(mappedBy = "post", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<PostLike> likes = new HashSet<>();

    // 카테고리 ID
    @Column(nullable = false)
    private Long categoryId;

    // UserId
    @Column(nullable = false)
    private Long userId;

    private Post(String title, String content, Long categoryId, Long userId) {
        this.title = title;
        this.content = content;
        this.categoryId = categoryId;
        this.userId = userId;
    }
    public static Post of(PostRequest postRequest, Long category, Long userId) {
        return new Post(
                postRequest.getTitle(),
                postRequest.getContent(),
                category,
                userId
        );
    }

    // 댓글은 postId로 가져오는식으로 해야겠다.
}
