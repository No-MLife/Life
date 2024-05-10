package com.m_life.m_life.domain;
import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Entity
public class PostCategory extends BaseTimeEntity{
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String boardName;

    @Column
    private String description;

    @OneToMany(mappedBy = "category")
    private List<Post> postList = new ArrayList<>();

    private PostCategory(String boardName, String description) {
        this.boardName = boardName;
        this.description = description;
    }

    public static PostCategory of (String boardName, String description) {
        return new PostCategory(boardName, description);
    }

    public void mappingPost(Post post) {
        this.postList.add(post);
    }

}
