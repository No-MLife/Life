package com.m_life.categoryservice.config;

import com.m_life.categoryservice.domain.PostCategory;
import com.m_life.categoryservice.repository.PostCategoryRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.util.ArrayList;

@Component
//@RequiredArgsConstructor
public class DataInitializer implements CommandLineRunner {
    private final PostCategoryRepository postCategoryRepository;



    public DataInitializer(PostCategoryRepository postCategoryRepository) {
        this.postCategoryRepository = postCategoryRepository;

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
                    "맛집",
                    "건설 현장 주변의 맛집 정보를 공유하는 게시판입니다."

            );
            postCategoryRepository.save(category3);

            PostCategory category4 = PostCategory.of(
                    "시공 방법",
                    "건설 현장에서 사용되는 다양한 시공 방법과 관련된 정보를 공유하는 게시판입니다."
            );
            postCategoryRepository.save(category4);

            PostCategory category5 = PostCategory.of(
                    "불만 토론",
                    "작업 환경, 처우 등에 대한 불만사항을 토론하고 개선방안을 모색하는 게시판입니다."
            );
            postCategoryRepository.save(category5);

            PostCategory category6 = PostCategory.of(
                    "장비 추천",
                    "건설 현장에서 사용되는 각종 장비, 공구 등에 대한 추천과 사용 팁을 공유하는 게시판입니다."
            );
            postCategoryRepository.save(category6);

            PostCategory category7 = PostCategory.of(
                    "현장 논쟁 분쟁",
                    "현장에서 발생하는 다양한 논쟁과 분쟁 사례를 공유하고 해결방안을 논의하는 게시판입니다."
            );
            postCategoryRepository.save(category7);




            PostCategory category8 = PostCategory.of(
                    "일당 인증",
                    "작업 완료 후 받은 일당을 인증하는 게시판입니다."
            );
            postCategoryRepository.save(category8);


        }


    }
}