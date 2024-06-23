package com.m_life.postservice.service;

import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.DeleteObjectRequest;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.PutObjectRequest;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
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
        String fileExtension = getFileExtension(file.getOriginalFilename());
        String fileName = UUID.randomUUID().toString() + fileExtension;
        String s3Key = "profile-images/" + fileName;
        return uploadImage(file, s3Key);
    }

    public List<String> uploadPostImages(List<MultipartFile> files, Long postId) {
        List<String> s3Urls = new ArrayList<>();
        for (MultipartFile file : files) {
            String fileExtension = getFileExtension(file.getOriginalFilename());
            String fileName = UUID.randomUUID().toString() + fileExtension;
            String s3Key = "post-images/" + postId + "/" + fileName;
            String s3Url = uploadImage(file, s3Key);
            s3Urls.add(s3Url);
        }
        return s3Urls;
    }

    private String uploadImage(MultipartFile file, String s3Key) {
        try {
            ObjectMetadata metadata = new ObjectMetadata();
            metadata.setContentLength(file.getSize());
            metadata.setContentType(file.getContentType());

            amazonS3.putObject(new PutObjectRequest(bucket, s3Key, file.getInputStream(), metadata));
        } catch (IOException e) {
            throw new RuntimeException("Failed to upload image to S3", e);
        }
        return amazonS3.getUrl(bucket, s3Key).toString();
    }

    public void deleteImage(String imageUrl) {
        String s3Key = imageUrl.substring(imageUrl.indexOf(".com/") + 5);
        amazonS3.deleteObject(new DeleteObjectRequest(bucket, s3Key));
    }

    private String getFileExtension(String fileName) {
        if (fileName != null && fileName.contains(".")) {
            return fileName.substring(fileName.lastIndexOf("."));
        }
        return "";
    }
}
