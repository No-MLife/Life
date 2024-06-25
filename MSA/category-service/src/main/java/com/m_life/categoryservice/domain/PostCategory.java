package com.m_life.categoryservice.domain;
import jakarta.persistence.*;
import lombok.*;

import java.io.Serializable;

@Data
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Entity
public class PostCategory implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String boardName;

    @Column
    private String description;


    private PostCategory(String boardName, String description) {
        this.boardName = boardName;
        this.description = description;
    }

    public static PostCategory of (String boardName, String description) {
        return new PostCategory(boardName, description);
    }

}
