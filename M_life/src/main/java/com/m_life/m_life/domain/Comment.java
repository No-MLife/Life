package com.m_life.m_life.domain;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.apache.catalina.User;

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
    @ManyToOne(optional = false)
    @JoinColumn(name = "useraccount_id")
    private UserAccount userAccount;


    private Comment(String content, Post post, UserAccount userAccount){
        this.content = content;
        this.post = post;
        this.userAccount = userAccount;
    }
    public static Comment of(String content, Post post, UserAccount userAccount){

        return new Comment(content, post, userAccount);
    }
}
