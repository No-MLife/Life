import React, { useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { getPostByIdApi } from '../../api/PostApi';
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
  const [comment, setComment] = useState('');
  const navigate = useNavigate();

  useEffect(() => {
    const loadPost = async () => {
      try {
        const data = await getPostByIdApi(postId);
        setPost(data);
        setLikeCount(data.likeCount);
      } catch (error) {
        console.error(error);
        setPost(null);
      } finally {
        setLoading(false);
      }
    };

    loadPost();
  }, [postId]);

  const handleLike = () => {
    setLikeCount(prev => prev + 1);
    // 여기서 서버에 좋아요 증가를 요청하는 API를 호출할 수 있습니다.
  };

  const handleCommentChange = (e) => {
    setComment(e.target.value);
  };

  const handleCommentSubmit = () => {
    // 댓글을 서버에 제출하는 로직을 구현합니다.
    console.log('댓글 제출:', comment);
    setComment('');
  };

  if (loading) {
    return <LoadingMessage>로딩 중...</LoadingMessage>;
  }

  if (!post) {
    return <LoadingMessage>포스트를 불러오지 못했습니다.</LoadingMessage>;
  }

  const category = Object.values(Category).find(cat => cat.id === post.categoryId);

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
                <PostAuthorAvatar src={logo} alt="author avatar" />
                <PostInfo>
                  <PostAuthor>{post.authorName}</PostAuthor>
                  <PostDate>{new Date(post.createAt).toLocaleDateString()}</PostDate>
                  <PostStats>댓글: {post.commentList.length} 좋아요: {likeCount}</PostStats>
                </PostInfo>
              </PostHeader>
              <PostTitle>{post.title} <LikeButton onClick={handleLike}>❤️ {likeCount}</LikeButton></PostTitle>
              <PostImages>
                {post.postImageUrls.map((url, index) => (
                  <PostImage key={index} src={url} alt={`post-${index}`} />
                ))}
              </PostImages>
              <PostContent>{post.content}</PostContent>
              <CommentSection>
                <CommentInput 
                  value={comment}
                  onChange={handleCommentChange}
                  placeholder="댓글을 입력하세요..."
                />
                <CommentButton onClick={handleCommentSubmit}>등록</CommentButton>
              </CommentSection>
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
  color: red;
  cursor: pointer;
`;

const PostImages = styled.div`
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  margin-bottom: 20px;
`;

const PostImage = styled.img`
  width: 100%;
  max-width: 300px;
  height: auto;
  border-radius: 8px;
`;

const PostContent = styled.div`
  font-size: 18px;
  line-height: 1.8;
  color: #444;
  margin-bottom: 20px;
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
  background-color: #f0ad4e;
  border: none;
  border-radius: 4px;
  cursor: pointer;
`;

const PostDetails = styled.div`
  display: flex;
  gap: 20px;
  font-size: 14px;
  color: #999;
  justify-content: center;
`;

const DetailItem = styled.span``;
