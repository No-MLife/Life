import React, { useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { getPostByIdApi, deletePostApi, putPostApi } from '../../api/PostApi';
import { getPostLikeApi, postPostLikeApi, deletePostLikeApi } from '../../api/PostLikeApi';
import { postCommentApi, putCommentApi, deleteCommentApi } from '../../api/CommentApi';
import { getUserProfileApi } from '../../api/UserApi'; // 프로필 API 가져오기
import styled from 'styled-components';
import Modal from '../../components/Modal'; // 모달 컴포넌트 가져오기
import {
  GlobalStyle,
  PageContainer,
  MainContent,
  SubHeader,
  SubTitle,
  ContentWrapper,
  LoadingMessage
} from '../../styles/commonStyles';
import logo from '../../assets/logo.png';
import { Category, getCategoryEmoji } from '../../components/Category';
import { useAuth } from '../../security/AuthContext'; // AuthContext 사용

const PostDetailPage = () => {
  const { postId } = useParams();
  const { isAuthenticated, username } = useAuth(); // 현재 로그인한 사용자 정보 가져오기
  const [post, setPost] = useState(null);
  const [loading, setLoading] = useState(true);
  const [likeCount, setLikeCount] = useState(0);
  const [isLiked, setIsLiked] = useState(false);
  const [comment, setComment] = useState('');
  const [editMode, setEditMode] = useState(false);
  const [editContent, setEditContent] = useState('');
  const [editCommentId, setEditCommentId] = useState(null);
  const [showModal, setShowModal] = useState(false);
  const [modalMessage, setModalMessage] = useState('');
  const [modalAction, setModalAction] = useState(() => () => {});
  const [authorAvatar, setAuthorAvatar] = useState(logo);
  const [commentAvatars, setCommentAvatars] = useState({});
  const navigate = useNavigate();

  useEffect(() => {
    const loadPost = async () => {
      try {
        const data = await getPostByIdApi(postId);
        setPost(data);
        setLikeCount(data.likeCount);
        checkIfLiked(postId); // 좋아요 여부 확인
        loadAuthorAvatar(data.authorName);
        loadCommentAvatars(data.commentList);
      } catch (error) {
        console.error(error);
        setPost(null);
      } finally {
        setLoading(false);
      }
    };

    const loadAuthorAvatar = async (authorName) => {
      try {
        const response = await getUserProfileApi(authorName);
        const profileData = response.data;
        setAuthorAvatar(profileData.profileImageUrl || logo);
      } catch (error) {
        console.error('Failed to load author avatar:', error);
      }
    };

    loadPost();
  }, [postId]);

  const loadCommentAvatars = async (comments) => {
    const avatars = {};
    await Promise.all(
      comments.map(async (comment) => {
        try {
          const response = await getUserProfileApi(comment.commentAuthor);
          avatars[comment.commentAuthor] = response.data.profileImageUrl || logo;
        } catch (error) {
          avatars[comment.commentAuthor] = logo;
          console.error('Failed to load comment author avatar:', error);
        }
      })
    );
    setCommentAvatars(avatars);
  };

  const checkIfLiked = async (postId) => {
    try {
      const data = await getPostLikeApi(postId);
      setIsLiked(data);
    } catch (error) {
      console.error('Failed to check if the post is liked:', error);
    }
  };

  const handleLikeToggle = async () => {
    if (!isAuthenticated) {
      window.alert('로그인이 필요합니다.');
      return;
    }

    try {
      if (isLiked) {
        await deletePostLikeApi(postId);
      } else {
        await postPostLikeApi(postId);
      }
      const data = await getPostByIdApi(postId);
      setLikeCount(data.likeCount);
      setIsLiked(!isLiked);
    } catch (error) {
      console.error('Failed to toggle like:', error);
    }
  };

  const handleCommentChange = (e) => {
    setComment(e.target.value);
  };

  const handleCommentSubmit = () => {
    if (!isAuthenticated) {
      window.alert('로그인이 필요합니다.');
      return;
    }

    setModalMessage('댓글을 등록하시겠습니까?');
    setModalAction(() => async () => {
      const CommentReqDto = {
        content: comment,
      };
      try {
        const response = await postCommentApi(postId, CommentReqDto);
        if (response.status === 200) {
          window.alert('댓글이 정상적으로 등록되었습니다.');
          const updatedPost = await getPostByIdApi(postId);
          setPost(updatedPost);
          await loadCommentAvatars(updatedPost.commentList); // 새로운 댓글에 대한 아바타 로드
        } else {
          window.alert('다시 확인해주세요');
        }
      } catch (error) {
        console.error('Failed to submit comment:', error);
        window.alert('다시 확인해주세요');
      }
      setComment('');
      setShowModal(false);
    });
    setShowModal(true);
  };

  const handleEditPost = () => {
    navigate(`/post/${postId}/edit`);
  };

  const handleDeletePost = () => {
    setModalMessage('포스트를 삭제하시겠습니까?');
    setModalAction(() => async () => {
      try {
        const response = await deletePostApi(postId);
        if (response.status === 200) {
          window.alert('포스트가 삭제되었습니다.');
          navigate('/');
        }
      } catch (error) {
        window.alert('다시 시도해주세요.');
      } finally {
        setShowModal(false);
      }
    });
    setShowModal(true);
  };

  // 댓글 수정
  const handleEditComment = async (commentId, content) => {
    setEditCommentId(commentId);
    setEditContent(content);
    console.log(content);
  };

  // 댓글 삭제
  const handleDeleteComment = (commentId) => {
    setModalMessage('댓글을 삭제하시겠습니까?');
    setModalAction(() => async () => {
      try {
        const response = await deleteCommentApi(postId, commentId);
        if (response.status === 200) {
          window.alert('댓글이 삭제되었습니다.');
          const updatedPost = await getPostByIdApi(postId);
          setPost(updatedPost);
          await loadCommentAvatars(updatedPost.commentList); // 새로운 댓글 목록에 대한 아바타 로드
        }
      } catch (error) {
        window.alert('다시 시도해주세요.');
      } finally {
        setShowModal(false);
      }
    });
    setShowModal(true);
  };

  const handleSaveEdit = async () => {
    if (editCommentId !== null) {
      setModalMessage('댓글을 수정하시겠습니까?');
      console.log(editContent);
      const CommentReqDto = {
        content: editContent,
      };
      setModalAction(() => async () => {
        try {
          const response = await putCommentApi(postId, editCommentId, CommentReqDto);
          if (response.status === 200) {
            window.alert('댓글이 수정되었습니다.');
            const updatedPost = await getPostByIdApi(postId);
            setPost(updatedPost);
            setEditCommentId(null);
          }
        } catch (error) {
          window.alert('다시 시도해주세요.');
        }
        setEditContent('');
        setShowModal(false);
      });
      setShowModal(true);
    } else {
      setModalMessage('포스트를 수정하시겠습니까?');
      setModalAction(() => async () => {
        try {
          const response = await putPostApi(postId, { content: editContent });
          if (response.status === 200) {
            window.alert('포스트가 수정되었습니다.');
            const updatedPost = await getPostByIdApi(postId);
            setPost(updatedPost);
            setEditMode(false);
          }
        } catch (error) {
          window.alert('다시 시도해주세요.');
        }
        setEditContent('');
        setShowModal(false);
      });
      setShowModal(true);
    }
  };

  const handleCancelEdit = () => {
    setEditMode(false);
    setEditCommentId(null);
    setEditContent('');
  };

  if (loading) {
    return <LoadingMessage>로딩 중...</LoadingMessage>;
  }

  if (!post) {
    return <LoadingMessage>포스트를 불러오지 못했습니다.</LoadingMessage>;
  }

  const category = Object.values(Category).find((cat) => cat.id === post.categoryId);

  const getAuthorAvatar = (authorName) => (commentAvatars[authorName] ? commentAvatars[authorName] : logo);

  return (
    <>
      <GlobalStyle />
      <PageContainer>
        <MainContent>
          <SubHeader>
            <StyledSubTitle>
              {getCategoryEmoji(category)} {category.name}
            </StyledSubTitle>
          </SubHeader>
          <StyledContentWrapper>
            <PostContainer>
              <PostHeader>
                <PostAuthorAvatar src={authorAvatar} alt="author avatar" />
                <PostInfo>
                  <PostAuthor>{post.authorName}</PostAuthor>
                  <PostDate>{new Date(post.createAt).toLocaleDateString()}</PostDate>
                  <PostStats>댓글: {post.commentList.length} 좋아요: {likeCount}</PostStats>
                </PostInfo>
              </PostHeader>
              {editMode ? (
                <>
                  <EditTextArea value={editContent} onChange={(e) => setEditContent(e.target.value)} />
                  <ButtonWrapper>
                    <EditButton onClick={handleSaveEdit}>저장</EditButton>
                    <EditButton onClick={handleCancelEdit}>취소</EditButton>
                  </ButtonWrapper>
                </>
              ) : (
                <>
                  <PostTitle>
                    {post.title}
                    <LikeButton $isLiked={isLiked.toString()} onClick={handleLikeToggle}>
                      {isLiked ? '❤️' : '🤍'} {likeCount}
                    </LikeButton>
                  </PostTitle>
                  <PostImages>
                    {post.postImageUrls.map((url, index) => (
                      <PostImage key={index} src={url} alt={`post-${index}`} />
                    ))}
                  </PostImages>
                  <PostContent>{post.content}</PostContent>
                  {username === post.authorName && (
                    <ButtonWrapper>
                      <EditButton onClick={handleEditPost}>✏️</EditButton>
                      <EditButton onClick={handleDeletePost}>🗑️</EditButton>
                    </ButtonWrapper>
                  )}
                </>
              )}
              
              <CommentList>
                {post.commentList.map((comment) => (
                  <Comment key={comment.id}>
                    <CommentAvatar src={getAuthorAvatar(comment.commentAuthor)} alt="comment author avatar" />
                    <CommentContentWrapper>
                      <CommentAuthor>{comment.commentAuthor}</CommentAuthor>
                      <CommentDate>{new Date(comment.createAt).toLocaleDateString()}</CommentDate>
                      {editCommentId === comment.id ? (
                        <>
                          <EditTextArea value={editContent} onChange={(e) => setEditContent(e.target.value)} />
                          <ButtonWrapper>
                            <EditButton onClick={handleSaveEdit}>저장</EditButton>
                            <EditButton onClick={handleCancelEdit}>취소</EditButton>
                          </ButtonWrapper>
                        </>
                      ) : (
                        <>
                          <CommentText>{comment.content}</CommentText>
                          {username === comment.commentAuthor && (
                            <ButtonWrapper>
                              <EditButton onClick={() => handleEditComment(comment.id, comment.content)}>✏️</EditButton>
                              <EditButton onClick={() => handleDeleteComment(comment.id)}>🗑️</EditButton>
                            </ButtonWrapper>
                          )}
                        </>
                      )}
                    </CommentContentWrapper>
                  </Comment>
                ))}
              </CommentList>
              <CommentSection>
                <CommentInput value={comment} onChange={handleCommentChange} placeholder="댓글을 입력하세요..." />
                <CommentButton onClick={handleCommentSubmit}>등록</CommentButton>
              </CommentSection>
            </PostContainer>
          </StyledContentWrapper>
        </MainContent>
      </PageContainer>
      <Modal
        show={showModal}
        onClose={() => setShowModal(false)}
        onConfirm={modalAction}
        message={modalMessage}
      />
    </>
  );
};

export default PostDetailPage;

// 포스트 디테일 페이지를 위한 스타일 컴포넌트
const PostContainer = styled.div`
  width: 100%;
  margin: 20px auto;
  padding: 20px;
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  position: relative;
`;

const PostHeader = styled.div`
  display: flex;
  align-items: center;
  margin-bottom: 20px;
`;

const PostAuthorAvatar = styled.img`
  width: 40px;
  height: 40px;
  border-radius: 50%;
  margin-right: 10px;
`;

const PostInfo = styled.div`
  display: flex;
  flex-direction: column;
  align-items: flex-start; /* 왼쪽 정렬 */
`;

const PostAuthor = styled.div`
  font-size: 16px;
  font-weight: bold;
  color: #333;
`;

const PostDate = styled.div`
  font-size: 14px;
  color: #666;
`;

const PostStats = styled.div`
  font-size: 14px;
  color: #666;
`;

const PostTitle = styled.h1`
  font-size: 24px;
  font-weight: bold;
  margin-bottom: 20px;
  color: #333;
  display: flex;
  align-items: center;
`;

const LikeButton = styled.button.attrs((props) => ({
  $isLiked: props.$isLiked
}))`
  background: none;
  border: none;
  font-size: 24px;
  margin-left: 10px;
  color: ${(props) => (props.$isLiked === 'true' ? 'red' : 'gray')};
  cursor: pointer;
`;

const PostImages = styled.div`
  display: flex;
  flex-direction: column; /* 세로 방향 정렬 */
  align-items: center; /* 이미지 중앙 정렬 */
  gap: 10px;
  margin-bottom: 20px;
`;

const PostImage = styled.img`
  width: 100%;
  max-width: 500px; /* 최대 너비를 500px로 설정 */
  height: auto;
  border-radius: 8px;
  object-fit: cover; /* 이미지의 비율을 유지하면서 콘텐츠 영역에 맞게 조절 */
  margin: auto; /* 이미지 중앙 정렬 */
`;

const PostContent = styled.div`
  font-size: 18px;
  line-height: 1.8;
  color: #444;
  margin-bottom: 20px;
  text-align: left; /* 텍스트 왼쪽 정렬 */
`;

const CommentSection = styled.div`
  display: flex;
  align-items: center;
  margin-top: 20px;
`;

const CommentInput = styled.input`
  flex: 1;
  padding: 10px;
  font-size: 16px;
  border: 1px solid #ccc;
  border-radius: 4px;
  margin-right: 10px;
  background-color: white; /* 배경색을 흰색으로 설정 */
  color: #000; /* 텍스트 색상을 검은색으로 설정 */

  &:focus {
    border-color: #ffca28; /* 포커스 상태에서 테두리 색상을 노란색으로 설정 */
    outline: none; /* 기본 포커스 아웃라인 제거 */
  }
`;

const CommentButton = styled.button`
  padding: 10px 20px;
  font-size: 16px;
  color: #fff;
  background-color: #ffca28;
  border: none;
  border-radius: 4px;
  cursor: pointer;
`;

const CommentList = styled.div`
  margin-top: 20px;
`;

const Comment = styled.div`
  display: flex;
  align-items: flex-start;
  padding: 10px;
  border-bottom: 1px solid #eee;
  margin-bottom: 10px;
  position: relative;
`;

const CommentAvatar = styled.img`
  width: 40px;
  height: 40px;
  border-radius: 50%;
  margin-right: 10px;
`;

const CommentContentWrapper = styled.div`
  display: flex;
  flex-direction: column;
  align-items: flex-start; /* 왼쪽 정렬 */
  flex-grow: 1;
`;

const CommentAuthor = styled.div`
  font-size: 14px;
  font-weight: bold;
  color: #333;
`;

const CommentDate = styled.div`
  font-size: 12px;
  color: #999;
  margin-top: 5px;
`;

const CommentText = styled.div`
  font-size: 16px;
  margin-top: 5px;
  color: #444;
  text-align: left; /* 텍스트 왼쪽 정렬 */
`;

const ButtonWrapper = styled.div`
  position: absolute;
  top: 10px;
  right: 10px;
  display: flex;
  gap: 5px;
`;

const EditButton = styled.button`
  padding: 5px 10px;
  font-size: 14px;
  color: #333;
  background-color: #fff;
  border: 1px solid #ccc;
  border-radius: 4px;
  cursor: pointer;
  transition: background-color 0.3s, border-color 0.3s;

  &:hover {
    background-color: #ffca28;
    border-color: #ffca28;
  }

  &:focus {
    background-color: #ffca28;
    border-color: #ffca28;
    outline: none;
  }
`;

const EditTextArea = styled.textarea`
  width: 100%;
  height: 100px;
  padding: 10px;
  font-size: 16px;
  border: 1px solid #ccc;
  border-radius: 4px;
  margin-top: 10px;
  background-color: white; /* 배경색을 흰색으로 설정 */
  color: #000; /* 텍스트 색상을 검은색으로 설정 */

  &:focus {
    border-color: #ffca28; /* 포커스 상태에서 테두리 색상을 노란색으로 설정 */
    outline: none; /* 기본 포커스 아웃라인 제거 */
  }
`;

const StyledSubTitle = styled(SubTitle)`
  margin-bottom: 10px; /* 조정한 마진 값 */
`;

const StyledContentWrapper = styled(ContentWrapper)`
  margin-top: 0; /* 조정한 마진 값 */
`;
