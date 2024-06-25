package com.m_life.commentservice.domain;

import jakarta.persistence.*;
import lombok.*;

@EqualsAndHashCode(callSuper = true)
@Data
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Entity
public class Comment extends BaseTimeEntity{
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 10000)
    private String content;

    @Column(nullable = false)
    private Long postId;
    @Column(nullable = false)
    private Long userId;


    private Comment(String content, Long postId, Long userId){
        this.content = content;
        this.postId = postId;
        this.userId = userId;
    }
    public static Comment of(String content, Long postId, Long userId){
        return new Comment(content, postId, userId);
    }
}
