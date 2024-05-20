package com.m_life.m_life.domain;

import com.m_life.m_life.dto.Experience;
import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Entity
public class UserProfile extends BaseTimeEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String profileImageUrl;

    private String introduction;

    private String jobName;

    @Enumerated(EnumType.STRING)
    private Experience experience;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_account_id")
    private UserAccount userAccount;

    public UserProfile(String profileImageUrl, String introduction, String jobName, Experience experience, UserAccount userAccount) {
        this.profileImageUrl = profileImageUrl;
        this.introduction = introduction;
        this.jobName = jobName;
        this.experience = experience;
        this.userAccount = userAccount;
    }

    public static UserProfile of(String profileImageUrl, String introduction,
                                 String jobName, Experience experience, UserAccount userAccount) {
        return new UserProfile(profileImageUrl, introduction, jobName, experience, userAccount);
    }
}