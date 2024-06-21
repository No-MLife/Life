package com.m_life.userservice.domain;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.*;

@Getter
@Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Entity
public class UserAccount extends BaseTimeEntity{
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;


    @Setter @Column(length = 100, unique = true) private String userid;
    @Setter @Column(nullable = false) private String userPassword;
    @Setter @Column(length = 100, unique = true) private String nickname;
    @Setter @Column(length = 200, unique = true) private String email;
    @Setter @Column(length = 100) private String role;


//    @OneToMany(mappedBy = "userAccount", cascade = CascadeType.ALL, orphanRemoval = true)
//    private Set<PostLike> likedPosts = new HashSet<>();
//
//    @OneToMany(mappedBy = "userAccount", cascade = CascadeType.ALL, orphanRemoval = true)
//    private List<Post> posts = new ArrayList<>();
//
//    @OneToMany(mappedBy = "userAccount", cascade = CascadeType.ALL, orphanRemoval = true)
//    private List<Comment> comments = new ArrayList<>();

    @OneToOne(mappedBy = "userAccount", cascade = CascadeType.ALL, orphanRemoval = true)
    private UserProfile userProfile;

    public UserAccount(String nickname, String username, String password, String email, String role) {
        this.nickname = nickname;
        this.userid = username;
        this.email = email;
        this.userPassword = password;
        this.role= role;
    }
    public static UserAccount of(String nickname, String username, String password, String email, String role){
        return new UserAccount(nickname, username, password, email, role);
    }


    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null || getClass() != obj.getClass()) {
            return false;
        }
        UserAccount other = (UserAccount) obj;
        return Objects.equals(id, other.id);
    }

    // hashCode 메서드도 오버라이드해야 함
    @Override
    public int hashCode() {
        return Objects.hash(id);
    }

}
