package com.m_life.m_life;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

@SpringBootApplication
@EnableJpaAuditing
public class MLifeApplication {

	public static void main(String[] args) {
		SpringApplication.run(MLifeApplication.class, args);
	}

}
