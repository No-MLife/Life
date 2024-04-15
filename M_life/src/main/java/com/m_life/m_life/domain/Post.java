package com.m_life.m_life.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
public class Post extends BaseTimeEntity{
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Setter
    @Column(nullable = false)
    private String title;

    @Setter
    @Column(nullable = false, length = 10000)
    private String content;

//    @Setter
//    private int like;

    // user 엔티티를 만들면 연결 해야함
//    @Setter
//    @ManyToOne(optional = false)
//    private String userId;


    protected Post() {

    }
    private Post(String title, String content){
        this.title = title;
        this.content = content;
    }
    public static Post of(String title, String content){
        return new Post(title, content);
    }
}
