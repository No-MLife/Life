package com.m_life.m_life.config;

import com.m_life.m_life.domain.Post;
import com.m_life.m_life.domain.PostCategory;
import com.m_life.m_life.domain.UserAccount;
import com.m_life.m_life.domain.UserProfile;
import com.m_life.m_life.dto.Experience;
import com.m_life.m_life.repository.*;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@Component
//@RequiredArgsConstructor
public class DataInitializer implements CommandLineRunner {
    private final PostCategoryRepository postCategoryRepository;
    private final UserProfileRepository userProfileRepository;
    private final UserAccountRepository userAccountRepository;
    private final PostRepository postRepository;

    private final BCryptPasswordEncoder bCryptPasswordEncoder;




    public DataInitializer(PostCategoryRepository postCategoryRepository, PostRepository postRepository, UserAccountRepository userAccountRepository, BCryptPasswordEncoder bCryptPasswordEncoder, UserProfileRepository userProfileRepository) {
        this.postCategoryRepository = postCategoryRepository;
        this.postRepository = postRepository;
        this.userAccountRepository = userAccountRepository;
        this.bCryptPasswordEncoder = bCryptPasswordEncoder;
        this.userProfileRepository = userProfileRepository;
    }

    @Override
    public void run(String... args) throws Exception {


        if (postCategoryRepository.count() == 0) {
            ArrayList<PostCategory>postCategories = new ArrayList<>();

            PostCategory category1 = PostCategory.of(
                    "인기 게시판",
                    "인기 게시글을 모아놓은 게시판입니다."
            );
            postCategoryRepository.save(category1);


            PostCategory category2= PostCategory.of(
                    "자유 게시판",
                    "자유롭게 글을 작성할 수 있는 게시판입니다."
            );
            postCategoryRepository.save(category2);

            PostCategory category3 = PostCategory.of(
                    "일당 인증",
                    "작업 완료 후 받은 일당을 인증하는 게시판입니다."
            );
            postCategoryRepository.save(category3);

            PostCategory category4 = PostCategory.of(
                    "시공 방법",
                    "건설 현장에서 사용되는 다양한 시공 방법과 관련된 정보를 공유하는 게시판입니다."
            );
            postCategoryRepository.save(category4);

            PostCategory category5 = PostCategory.of(
                    "졸업 후기",
                    "건설 관련 교육 과정을 졸업한 후 현장에서의 경험과 후기를 공유하는 게시판입니다."
            );
            postCategoryRepository.save(category5);

            PostCategory category6 = PostCategory.of(
                    "불만 토론",
                    "작업 환경, 처우 등에 대한 불만사항을 토론하고 개선방안을 모색하는 게시판입니다."
            );
            postCategoryRepository.save(category6);

            PostCategory category7 = PostCategory.of(
                    "현장 논쟁 분쟁",
                    "현장에서 발생하는 다양한 논쟁과 분쟁 사례를 공유하고 해결방안을 논의하는 게시판입니다."
            );
            postCategoryRepository.save(category7);

            PostCategory category8 = PostCategory.of(
                    "노조 관련",
                    "건설 노동조합과 관련된 소식, 활동, 정보 등을 공유하는 게시판입니다."
            );
            postCategoryRepository.save(category8);

            PostCategory category9 = PostCategory.of(
                    "장비 추천",
                    "건설 현장에서 사용되는 각종 장비, 공구 등에 대한 추천과 사용 팁을 공유하는 게시판입니다."
            );
            postCategoryRepository.save(category9);

            PostCategory category10 = PostCategory.of(
                    "맛집",
                    "건설 현장 주변의 맛집 정보를 공유하는 게시판입니다."
            );
            postCategoryRepository.save(category10);


            // 유저 2~3명 생성
            UserAccount sample = UserAccount.of("메가커피", "sample", bCryptPasswordEncoder.encode("123123"), "ROLE_USER");
            UserAccount user = UserAccount.of("허훈도령", "test", bCryptPasswordEncoder.encode("123123"), "ROLE_USER");
            UserAccount user1 = UserAccount.of("콩쥐들쥐", "test1", bCryptPasswordEncoder.encode("123123"), "ROLE_USER");
            UserAccount user2 = UserAccount.of("현모양초", "test2", bCryptPasswordEncoder.encode("123123"), "ROLE_USER");
            UserAccount user3 = UserAccount.of("휴지필름", "test3", bCryptPasswordEncoder.encode("123123"), "ROLE_USER");
            userAccountRepository.saveAll(Arrays.asList(sample, user, user1, user2, user3));

            UserProfile userProfile = UserProfile.of(
                    "https://mlifeapp.s3.ap-northeast-2.amazonaws.com/profile-images/63169b9f-9d5a-4473-969e-76904263a0dd_copy_logo+%E1%84%87%E1%85%A9%E1%86%A8%E1%84%89%E1%85%A1%E1%84%87%E1%85%A9%E1%86%AB.png",
                    "한 줄 자기소개","", Experience.ZERO_YEAR, sample
            );
            userProfileRepository.save(userProfile);
            UserProfile userProfile1 = UserProfile.of(
                    "https://mlifeapp.s3.ap-northeast-2.amazonaws.com/profile-images/63169b9f-9d5a-4473-969e-76904263a0dd_copy_logo+%E1%84%87%E1%85%A9%E1%86%A8%E1%84%89%E1%85%A1%E1%84%87%E1%85%A9%E1%86%AB.png",
                    "한 줄 자기소개","",Experience.ZERO_YEAR, user
            );
            userProfileRepository.save(userProfile1);
            UserProfile userProfile2 = UserProfile.of(
                    "https://mlifeapp.s3.ap-northeast-2.amazonaws.com/profile-images/63169b9f-9d5a-4473-969e-76904263a0dd_copy_logo+%E1%84%87%E1%85%A9%E1%86%A8%E1%84%89%E1%85%A1%E1%84%87%E1%85%A9%E1%86%AB.png",
                    "한 줄 자기소개","",Experience.ZERO_YEAR, user1
            );
            userProfileRepository.save(userProfile2);

            UserProfile userProfile3 = UserProfile.of(
                    "https://mlifeapp.s3.ap-northeast-2.amazonaws.com/profile-images/63169b9f-9d5a-4473-969e-76904263a0dd_copy_logo+%E1%84%87%E1%85%A9%E1%86%A8%E1%84%89%E1%85%A1%E1%84%87%E1%85%A9%E1%86%AB.png",
                    "한 줄 자기소개","",Experience.ZERO_YEAR, user2
            );
            userProfileRepository.save(userProfile3);
            UserProfile userProfile4 = UserProfile.of(
                    "https://mlifeapp.s3.ap-northeast-2.amazonaws.com/profile-images/63169b9f-9d5a-4473-969e-76904263a0dd_copy_logo+%E1%84%87%E1%85%A9%E1%86%A8%E1%84%89%E1%85%A1%E1%84%87%E1%85%A9%E1%86%AB.png",
                    "한 줄 자기소개","",Experience.ZERO_YEAR, user3
            );
            userProfileRepository.save(userProfile4);

            postCategories.addAll(Arrays.asList(category1, category2, category3, category4, category5, category6, category7, category8, category9, category10));
            // 게시글
            List<Post> posts = new ArrayList<>();
            for (int i = 0; i < 10; i++) {
                Post post = Post.of("title" + i, "content" + i, postCategories.get(i));
                post.setUserAccount(user);
                posts.add(post);
            }
            postRepository.saveAll(posts);
        }


    }
}