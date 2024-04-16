package com.m_life.m_life.domain;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Entity
public class UserAccount {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;


    @Setter @Column(nullable = false) private String userPassword;
    @Setter @Column(length = 100) private String nickname;
    @Setter @Column(length = 100) private String userid;
    @Setter @Column(length = 100) private String role;

    public UserAccount(String nickname, String username, String password, String role) {
        this.nickname = nickname;
        this.userid = username;
        this.userPassword = password;
        this.role= role;
    }
    public static UserAccount of(String nickname, String username, String password, String role){
        return new UserAccount(nickname, username, password, role);
    }






}
