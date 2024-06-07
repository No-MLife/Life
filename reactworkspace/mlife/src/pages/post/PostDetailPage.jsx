import React, { useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { getPostByIdApi } from '../../api/PostApi';
import {getPostLikeApi, postPostLikeApi, deletePostLikeApi} from '../../api/PostLike'
import styled from 'styled-components';
import {
  GlobalStyle,
  PageContainer,
  MainContent,
  Header,
  SubHeader,
  SubTitle,
  TopNav,
  NavButton,
  LogoImage,
  ContentWrapper,
  NavBar,
  NavItem,
  Emoji,
  LoadingMessage
} from '../../styles/commonStyles';
import logo from '../../assets/logo.png';
import { Category, getCategoryEmoji } from '../../components/category';

const PostDetailPage = () => {
  const { postId } = useParams();
  const [post, setPost] = useState(null);
  const [loading, setLoading] = useState(true);
  const [likeCount, setLikeCount] = useState(0);
  const [isLiked, setIsLiked] = useState(false);
  const [comment, setComment] = useState('');
  const [editMode, setEditMode] = useState(false);
  const [editContent, setEditContent] = useState('');
  const [editCommentId, setEditCommentId] = useState(null);
  const navigate = useNavigate();

  useEffect(() => {
    const loadPost = async () => {
      try {
        const data = await getPostByIdApi(postId);
        setPost(data);
        setLikeCount(data.likeCount);
        checkIfLiked(postId); // 좋아요 여부 확인
      } catch (error) {
        console.error(error);
        setPost(null);
      } finally {
        setLoading(false);
      }
    };

    loadPost();
  }, [postId]);

  const checkIfLiked = async (postId) => {
    try {
      const isLiked = await getPostLikeApi(postId);
      setIsLiked(isLiked);
    } catch (error) {
      console.error('Failed to check if the post is liked:', error);
    }
  };

  const handleLikeToggle = async () => {
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
    console.log('댓글 제출:', comment);
    setComment('');
  };

  const handleEditPost = () => {
    setEditMode(true);
    setEditContent(post.content);
  };

  const handleDeletePost = () => {
    console.log('포스트 삭제');
  };

  const handleEditComment = (commentId, content) => {
    setEditCommentId(commentId);
    setEditContent(content);
  };

  const handleDeleteComment = (commentId) => {
    console.log('댓글 삭제', commentId);
  };

  const handleSaveEdit = () => {
    if (editCommentId !== null) {
      console.log('댓글 수정', editCommentId, editContent);
      setEditCommentId(null);
    } else {
      console.log('포스트 수정', editContent);
      setEditMode(false);
    }
    setEditContent('');
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

  const category = Object.values(Category).find(cat => cat.id === post.categoryId);

  const getAuthorAvatar = (avatarUrl) => (avatarUrl ? avatarUrl : logo);

  return (
    <>
      <GlobalStyle />
      <PageContainer>
        <MainContent>
          <Header>
            <LogoImage src={logo} alt="M-Life Logo" onClick={() => navigate('/')} />
            <TopNav>
              <NavButton onClick={() => navigate('/login')}>로그인</NavButton>
              <NavButton onClick={() => navigate('/signup')}>회원가입</NavButton>
            </TopNav>
            <NavBar>
              {Object.values(Category).map((category) => (
                <NavItem key={category.id} onClick={() => navigate(`/${category.id}`)}>
                  <Emoji>{getCategoryEmoji(category)}</Emoji> {category.name}
                </NavItem>
              ))}
            </NavBar>
          </Header>
          <SubHeader>
            <SubTitle>{getCategoryEmoji(category)} {category.name}</SubTitle>
          </SubHeader>
          <ContentWrapper>
            <PostContainer>
              <PostHeader>
                <PostAuthorAvatar src={getAuthorAvatar(post.authorAvatarUrl)} alt="author avatar" />
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
                    <LikeButton onClick={handleLikeToggle} isLiked={isLiked}>
                      {isLiked ? '❤️' : '🤍'} {likeCount}
                    </LikeButton>
                  </PostTitle>
                  <PostImages>
                    {post.postImageUrls.map((url, index) => (
                      <PostImage key={index} src={url} alt={`post-${index}`} />
                    ))}
                  </PostImages>
                  <PostContent>{post.content}</PostContent>
                  <ButtonWrapper>
                    <EditButton onClick={handleEditPost}>✏️</EditButton>
                    <EditButton onClick={handleDeletePost}>🗑️</EditButton>
                  </ButtonWrapper>
                </>
              )}
              <CommentSection>
                <CommentInput 
                  value={comment}
                  onChange={handleCommentChange}
                  placeholder="댓글을 입력하세요..."
                />
                <CommentButton onClick={handleCommentSubmit}>등록</CommentButton>
              </CommentSection>
              <CommentList>
                {post.commentList.map((comment) => (
                  <Comment key={comment.id}>
                    <CommentAvatar src={getAuthorAvatar(comment.authorAvatarUrl)} alt="comment author avatar" />
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
                          <ButtonWrapper>
                            <EditButton onClick={() => handleEditComment(comment.id, comment.content)}>✏️</EditButton>
                            <EditButton onClick={() => handleDeleteComment(comment.id)}>🗑️</EditButton>
                          </ButtonWrapper>
                        </>
                      )}
                    </CommentContentWrapper>
                  </Comment>
                ))}
              </CommentList>
            </PostContainer>
          </ContentWrapper>
        </MainContent>
      </PageContainer>
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

const LikeButton = styled.button`
  background: none;
  border: none;
  font-size: 24px;
  margin-left: 10px;
  color: ${props => (props.isLiked ? 'red' : 'gray')};
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
`;
