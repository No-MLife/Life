package com.m_life.m_life.domain;

import com.m_life.m_life.dto.Experience;
import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Entity
public class PostImage extends BaseTimeEntity{
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String fileName;

    @Column(nullable = false)
    private String s3Url;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "post_id")
    private Post post;

    public PostImage(String fileName, String s3Url, Post post) {
        this.fileName = fileName;
        this.s3Url = s3Url;
        this.post = post;
    }

    public static PostImage of(String fileName, String s3Url, Post post) {
        return new PostImage(fileName, s3Url, post);
    }
}