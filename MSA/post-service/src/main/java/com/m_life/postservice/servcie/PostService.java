package com.m_life.postservice.servcie;

import com.m_life.postservice.domain.Post;
import com.m_life.postservice.domain.PostImage;
import com.m_life.postservice.dto.PostRequest;
import com.m_life.postservice.dto.UserResponse;
import com.m_life.postservice.repository.PostImageRepository;
import com.m_life.postservice.repository.PostRepository;
import com.m_life.postservice.dto.PostResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;

import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

@Slf4j
@Service
@RequiredArgsConstructor
public class PostService {

    private final PostRepository postRepository;
    private final PostImageRepository postImageRepository;
    private final com.m_life.postservice.service.S3Service s3Service;
    private final RestTemplate restTemplate;

    // ============================================= READ ======================================================
    @Transactional(readOnly = true)
    // 특정 게시글 조회(로그인 X)
    public ResponseEntity<PostResponse> getPostById(Long postId) {
        // step1. 특정 게시글 가져오기
        Post post = postRepository.findById(postId).orElseThrow(
                () ->  new ResponseStatusException(HttpStatus.NOT_FOUND, "해당 게시글이 존재하지 않습니다. 다시 확인해주세요.")
        );

        try {
            // step2. post 객체를 response 객체로 변환
            PostResponse responsePost = PostResponse.fromPost(post);

            // step3. user 정보를 받아와서 닉네임 변경
            responsePost.setAuthorName(getAuthorName(-1L)); // 실제 작성자 이름으로 설정

            // step4. category 정보를 받아와서 보드 이름과 설명 삽입
            responsePost.setBoardName("Board Name"); // 실제 보드 이름으로 설정
            responsePost.setDescription("Description"); // 실제 설명으로 설정

            //  step5. 이거 어카지 + 댓글은 어카지? postid로 댓글 가져와야 할ㅇ듯
            responsePost.setAuthorLikes(0L); // 실제 작성자 좋아요 수로 설정
            return ResponseEntity.status(HttpStatus.OK).body(responsePost);
        }
        catch (Exception e){
            return ResponseEntity.badRequest().body(null);
        }
    }
    @Transactional(readOnly = true)
    // 유저별 게시글 전체 조회(로그인 고민중...)
    public ResponseEntity<List<PostResponse>> getPostsByUserId(Long userId) {
        // step1. 유저가 작성한 게시글들을 모두 가져옴(user 고유 id로 조회해야함) -> 유저id가 없는경우 생각해야겠네
        if(userId  != 1){
            return ResponseEntity.badRequest().body(null);
        }

        List<Post> posts = postRepository.findAllByUserId(userId);

        List<PostResponse> responsePosts = new ArrayList<>();
        // step2. post 객체를 response 객체로 변환
        responsePosts = posts.stream().map(
                post -> {
                    PostResponse responsePost = PostResponse.fromPost(post);

                    // User 정보를 받아와서 닉네임 설정
                    String authorName = getAuthorName(-1L);
                    responsePost.setAuthorName(authorName);

                    // Category 정보를 받아와서 보드 이름과 설명 설정
                    responsePost.setBoardName("Board Name"); // 실제 보드 이름으로 설정
                    responsePost.setDescription("Description"); // 실제 설명으로 설정

                    // 작성자 좋아요 수 설정 (여기서는 예시로 0으로 설정)
                    responsePost.setAuthorLikes(0L);

                    return responsePost;
                }).toList();
        return ResponseEntity.ok(responsePosts);
    }

    private String getAuthorName(Long userId) {
        return "Author Name";
    }

    @Transactional(readOnly = true)
    // 카테고리별 게시글 전체 조회(로그인 X)
    public ResponseEntity<List<PostResponse>> getPostsByCategory(Long categoryId) {
        // step1. 카테고리별 게시글들을 모두 가져옴
        List<Post> posts = postRepository.findAllByCategoryId(categoryId);
        if(posts.isEmpty()){
            log.info("해당 카테고리 ID: {} 에 맞는 게시글이 존재하지 않습니다.", categoryId);
        }

        List<PostResponse> responsePosts = new ArrayList<>();
        // step2. post 객체를 response 객체로 변환
        responsePosts = posts.stream().map(
                post -> {
                    PostResponse responsePost = PostResponse.fromPost(post);

                    // User 정보를 받아와서 닉네임 설정
                    String authorName = getAuthorName(-1L);
                    responsePost.setAuthorName(authorName);

                    // Category 정보를 받아와서 보드 이름과 설명 설정
                    responsePost.setBoardName("Board Name"); // 실제 보드 이름으로 설정
                    responsePost.setDescription("Description"); // 실제 설명으로 설정

                    // 작성자 좋아요 수 설정 (여기서는 예시로 0으로 설정)
                    responsePost.setAuthorLikes(0L);

                    return responsePost;
                }).toList();
        return ResponseEntity.ok(responsePosts);

    }
    // ============================================= READ ======================================================


    // ============================================= CREATE ======================================================
    public ResponseEntity<String> createPost(PostRequest postRequest, List<MultipartFile> files) {
        // request dto에서 가져와서 작성을 해야함

        // step1 해당 카테고리가 있는지 확인
        Long category = postRequest.getCategoryId();

        // step2. 해당 유저가 있는지 확인
        String userUrl = String.format("http://127.0.0.1:8000/user-service/users/%s", postRequest.getUserId());
        ResponseEntity<UserResponse> userResponseResponseEntity =
                restTemplate.exchange(userUrl, HttpMethod.GET, null, new ParameterizedTypeReference<UserResponse>() {
                });
        UserResponse userResponse = userResponseResponseEntity.getBody();
        if(Objects.requireNonNull(userResponse).getNickname().isBlank()){
            return ResponseEntity.badRequest().body("해당 유저가 존재하지 않습니다. 다시 확인해주세요.");
        }

        // step2-1 유저에서 닉네임 가져오기(필요없을듯... 반환해줄때만 필요할듯)
        String nickname = userResponse.getNickname();

        // step3. 포스트 생성
        Post post = Post.of(postRequest, category, userResponse.getId());
        // 생성은 그냥 하고 반환할 때 닉네임으로 반환해주는 방식을 생각하자
        postRepository.save(post);

        // step4. 이미지가 있는 경우 이미지도 같이 저장
        if (files != null && !files.isEmpty()) {
            uploadImages(post, files);
            postRepository.save(post);
        }
        return ResponseEntity.status(HttpStatus.CREATED).body("게시글 작성이 완료되었습니다.");
    }
    private void uploadImages(Post post, List<MultipartFile> files) {
        List<String> s3Urls = s3Service.uploadPostImages(files, post.getId());

        List<PostImage> postImages = IntStream.range(0, s3Urls.size())
                .mapToObj(i -> PostImage.of(files.get(i).getOriginalFilename(), s3Urls.get(i), post))
                .toList();

        post.getImages().addAll(postImages);
    }

    // ============================================= CREATE ======================================================



    // ============================================= UPDATE ======================================================
    @Transactional
    public ResponseEntity<String> updatePost(PostRequest postRequest, List<MultipartFile> files) {
        try{
            // step1. 해당 포스트 가져옴
            Post post = postRepository.findById(postRequest.getId())
                    .orElseThrow(
                            () ->  new ResponseStatusException(HttpStatus.NOT_FOUND, "해당 게시글이 존재하지 않습니다. 다시 확인해주세요.")
                    );
            // step2. 게시글 유저와 현재 게시글 수정을 요청한 유저가 다른경우 수정 불가능
            if (!post.getUserId().equals(postRequest.getUserId())) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body("수정 권한이 없습니다.");
            }
            // step3-1. 타이틀, 내용, 이미지, 카테고리 id등 변경점이 있다면 변경
            if (postRequest.getTitle() != null) {
                post.setTitle(postRequest.getTitle());
            }
            if (postRequest.getContent() != null) {
                post.setContent(postRequest.getContent());
            }
            if(postRequest.getCategoryId() != 1){
                post.setCategoryId(postRequest.getCategoryId());
            }
            // 3-2 새로운 이미지 업로드
            List<String> newImageUrls = (files != null && !files.isEmpty()) ?
                    s3Service.uploadPostImages(files, post.getId()) :
                    List.of();

            // 3-3 기존 URL 유지 및 새 URL 추가
            Set<String> currentImageUrls = new HashSet<>(postRequest.getPostImageUrls());
            currentImageUrls.addAll(newImageUrls);

            // 3-4 기존 이미지 삭제 로직 - 새로운 URL에 포함되지 않은 기존 이미지 필터링
            List<PostImage> imagesToDelete = post.getImages().stream()
                    .filter(image -> !currentImageUrls.contains(image.getS3Url()))
                    .collect(Collectors.toList());

            for (PostImage image : imagesToDelete) {
                s3Service.deleteImage(image.getS3Url());
            }

            postImageRepository.deleteAll(imagesToDelete);
            post.getImages().removeAll(imagesToDelete);



            // 3-5 새 이미지를 포스트에 추가
            List<PostImage> uploadedImages = newImageUrls.stream()
                    .map(url -> new PostImage("generated-filename", url, post)) // 파일명을 관리하는 로직이 필요할 수 있음
                    .toList();

            post.getImages().addAll(uploadedImages);
            postRepository.save(post);

            return ResponseEntity.ok("게시글 수정이 완료되었습니다.");

        }catch (Exception e){
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("게시글 수정 중 오류가 발생했습니다.");
        }
    }
    // ============================================= UPDATE ======================================================

    // ============================================= DELETE ======================================================
    public ResponseEntity<String> delete(Long userId, Long postId) {
        // step1. post 찾기
        Post post = postRepository.findById(postId)
                .orElseThrow(
                        () ->  new ResponseStatusException(HttpStatus.NOT_FOUND, "해당 게시글이 존재하지 않습니다. 다시 확인해주세요.")
                );
        // step2. 게시글 유저와 현재 게시글 수정을 요청한 유저가 다른경우 수정 불가능
        if (!post.getUserId().equals(userId)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("삭제 권한이 없습니다.");
        }
        //
        // Step3-1 S3에 저장된 이미지 삭제

        if (!post.getImages().isEmpty()) {
            for (PostImage image : post.getImages()) {
                s3Service.deleteImage(image.getS3Url());
            }
            postImageRepository.deleteAll(post.getImages());
        }
        postRepository.deleteById(postId);
        return ResponseEntity.ok().body("게시글이 정상적으로 삭제되었습니다.");
    }
    // ============================================= DELETE ======================================================
}
