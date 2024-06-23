package com.m_life.userservice.config;
import com.m_life.userservice.domain.UserAccount;
import com.m_life.userservice.domain.UserProfile;
import com.m_life.userservice.dto.Experience;
import com.m_life.userservice.repository.UserAccountRepository;
import com.m_life.userservice.repository.UserProfileRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Arrays;

@Component
//@RequiredArgsConstructor
public class DataInitializer implements CommandLineRunner {

    private final UserProfileRepository userProfileRepository;
    private final UserAccountRepository userAccountRepository;
    private final BCryptPasswordEncoder bCryptPasswordEncoder;



    public DataInitializer(UserProfileRepository userProfileRepository, UserAccountRepository userAccountRepository,
                           BCryptPasswordEncoder bCryptPasswordEncoder) {
        this.userProfileRepository = userProfileRepository;
        this.userAccountRepository = userAccountRepository;
        this.bCryptPasswordEncoder = bCryptPasswordEncoder;
    }

    @Override
    public void run(String... args) throws Exception {




//             유저 2~3명 생성
            UserAccount sample = UserAccount.of("멥쌀가루", "sample", bCryptPasswordEncoder.encode("123123"), "sample@nate.com", "ROLE_USER");
            UserAccount user = UserAccount.of("아칸소주", "test", bCryptPasswordEncoder.encode("123123"), "sample1@nate.com","ROLE_USER");
            UserAccount user1 = UserAccount.of("콩쥐들쥐", "test1", bCryptPasswordEncoder.encode("123123"), "sampl2@nate.com", "ROLE_USER");
            UserAccount user2 = UserAccount.of("현모양초", "test2", bCryptPasswordEncoder.encode("123123"), "sample3@nate.com","ROLE_USER");
            UserAccount user3 = UserAccount.of("휴지필름", "test3", bCryptPasswordEncoder.encode("123123"), "sample4@nate.com","ROLE_USER");
            userAccountRepository.saveAll(Arrays.asList(sample, user, user1, user2, user3));
//
            UserProfile userProfile = UserProfile.of(
                    "",
                    "한 줄 자기소개","", Experience.ZERO_YEAR, sample
            );
            userProfileRepository.save(userProfile);
            UserProfile userProfile1 = UserProfile.of(
                    "",
                    "한 줄 자기소개","",Experience.ZERO_YEAR, user
            );
            userProfileRepository.save(userProfile1);
            UserProfile userProfile2 = UserProfile.of(
                    "",
                    "한 줄 자기소개","",Experience.ZERO_YEAR, user1
            );
            userProfileRepository.save(userProfile2);

            UserProfile userProfile3 = UserProfile.of(
                    "",
                    "한 줄 자기소개","",Experience.ZERO_YEAR, user2
            );
            userProfileRepository.save(userProfile3);
            UserProfile userProfile4 = UserProfile.of(
                    "",
                    "한 줄 자기소개","",Experience.ZERO_YEAR, user3
            );
            userProfileRepository.save(userProfile4);

    }
}