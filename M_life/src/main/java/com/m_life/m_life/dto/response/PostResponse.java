package com.m_life.m_life.dto.response;

import com.m_life.m_life.domain.Comment;
import com.m_life.m_life.domain.Post;
import com.m_life.m_life.domain.PostCategory;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

public record PostResponse(
        Long id,
        String title,
        String content,
        LocalDateTime createAt,
        List<CommentResponse> commentList,
        int likeCount,
        String authorName, // 작성자 이름 필드 추가
        String boardName,
        String description
) {
    public static PostResponse of(Long id, String title, String content, LocalDateTime localDateTime, List<CommentResponse> commentList, int likeCount,
                                  String authorName, String boardName, String description) {
        return new PostResponse(id, title, content, localDateTime, commentList, likeCount, authorName, boardName, description);
    }

    public static PostResponse from(Post post) {
        return new PostResponse(
                post.getId(),
                post.getTitle(),
                post.getContent(),
                post.getCreateDate(),
                post.getCommentList().stream().map(CommentResponse::from).collect(Collectors.toList()),
                post.getLikes().size(), // 좋아요 개수 계산,
                post.getUserAccount().getNickname(),
                post.getCategory().getBoardName(),
                post.getCategory().getDescription()
        );
    }
}
