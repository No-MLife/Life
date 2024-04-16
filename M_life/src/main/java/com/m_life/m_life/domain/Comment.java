package com.m_life.m_life.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
public class Comment extends BaseTimeEntity{
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Setter
    @Column(nullable = false, length = 10000)
    private String content;

    @Setter
    @ManyToOne(optional = false)
    @JoinColumn(name = "post_id")
    private Post post;

    protected Comment() {

    }
    private Comment(String content, Post post){
        this.content = content;
        this.post = post;
    }
    public static Comment of(String content, Post post){

        return new Comment(content, post);
    }
}
