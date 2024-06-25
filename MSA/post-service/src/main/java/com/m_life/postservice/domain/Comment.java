package com.m_life.postservice.domain;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Entity
public class Comment extends BaseTimeEntity{
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Setter
    @Column(nullable = false, length = 10000)
    private String content;

    @Setter
    @ManyToOne(optional = false)
    @JoinColumn(name = "post_id")
    private Post post;

    @Setter
    private Long userID;

    private Comment(String content, Post post, Long userID){
        this.content = content;
        this.post = post;
        this.userID = userID;
    }
    public static Comment of(String content, Post post, Long userID){
        return new Comment(content, post, userID);
    }
}
