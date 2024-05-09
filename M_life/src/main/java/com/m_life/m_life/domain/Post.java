package com.m_life.m_life.domain;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Getter
@Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
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

    @Setter
    @Column(nullable = false)
    private int view_count;


    @OneToMany(mappedBy = "post", cascade = CascadeType.REMOVE)
    private List<Comment> commentList = new ArrayList<>();


    @OneToMany(mappedBy = "post", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<PostLike> likes = new HashSet<>();


    @Setter
    @ManyToOne(optional = false)
    @JoinColumn(name = "useraccount_id")
    private UserAccount userAccount;

    @Setter
    @ManyToOne(optional = false)
    @JoinColumn(name = "category_id")
    private PostCategory category;


    private Post(String title, String content, PostCategory category) {
        this.title = title;
        this.content = content;
        this.category = category;
    }



    public static Post of(String title, String content, PostCategory category) {
        return new Post(title, content, category);
    }

    public void mappingCategory(PostCategory postCategory){
        this.category = postCategory;
        postCategory.mappingPost(this);
    }
}
