package com.m_life.m_life.service;

import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.PutObjectRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.UUID;

@Service
public class S3Service {
    private final AmazonS3 amazonS3;
    private final String bucket;

    public S3Service(AmazonS3 amazonS3, @Value("${cloud.aws.s3.bucket}") String bucket) {
        this.amazonS3 = amazonS3;
        this.bucket = bucket;
    }

    public String uploadProfileImage(MultipartFile file) {
        String fileName = file.getOriginalFilename();
        String s3Key = "profile-images/" + UUID.randomUUID() + "_" + fileName;
        return uploadImage(file, s3Key);
    }

    public String uploadPostImage(MultipartFile file, Long postId) {
        String fileName = file.getOriginalFilename();
        String s3Key = "post-images/" + postId + "/" + UUID.randomUUID() + "_" + fileName;
        return uploadImage(file, s3Key);
    }

    private String uploadImage(MultipartFile file, String s3Key) {
        try {
            ObjectMetadata metadata = new ObjectMetadata();
            metadata.setContentType(file.getContentType());
            amazonS3.putObject(new PutObjectRequest(bucket, s3Key, file.getInputStream(), metadata));
        } catch (IOException e) {
            // 예외 처리
        }
        return amazonS3.getUrl(bucket, s3Key).toString();
    }
}