import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import logo from '../../assets/logo.png';
import {
  GlobalStyle,
  PageContainer,
  MainContent,
  SubHeader,
  SubTitle,
  ContentWrapper,
  PostCard,
  Thumbnail,
  PostContent,
  PostInfo,
  PostCategory,
  PostTitle,
  PostDescription,
  PostDetails,
  DetailItem,
  LoadingMessage
} from '../../styles/commonStyles';
import styled from 'styled-components';
import { getPopulaPostsApi } from '../../api/PostApi';
import { useAuth } from '../../security/AuthContext'; // AuthContext 사용

const Home = () => {
  const [posts, setPosts] = useState([]);
  const [loading, setLoading] = useState(true);
  const navigate = useNavigate();
  const { isAuthenticated } = useAuth(); // 현재 로그인 여부 확인

  useEffect(() => {
    const loadPosts = async () => {
      try {
        const data = await getPopulaPostsApi();
        if (Array.isArray(data)) {
          setPosts(data);
        } else {
          setPosts([]);
        }
      } catch (error) {
        console.error(error);
        setPosts([]);
      } finally {
        setLoading(false);
      }
    };

    loadPosts();
  }, []);

  const handleWriteButtonClick = () => {
    if (!isAuthenticated) {
      window.alert('로그인이 필요합니다. 로그인 페이지로 이동합니다.');
      navigate('/login');
    } else {
      navigate('/write');
    }
  };

  if (loading) {
    return <LoadingMessage>로딩 중...</LoadingMessage>;
  }

  return (
    <>
      <GlobalStyle />
      <PageContainer>
        <MainContent>
          <ContentWrapper>
            <SubHeader>
              <SubTitle><FireIcon>🔥</FireIcon> 인기 게시글 100</SubTitle>
              <WriteButton onClick={handleWriteButtonClick}>✏️ 글쓰기</WriteButton>
            </SubHeader>
            <PostList>
              {posts.map((post, index) => (
                <PostCard key={post.id} onClick={() => navigate(`/post/${post.id}`)}>
                  <Thumbnail src={post.postImageUrls[0] || logo} alt={post.title} />
                  <PostContent>
                    <PostInfo>
                      <PostCategory>[{post.boardName}]</PostCategory>
                      <PostTitle>{post.title}</PostTitle>
                      <PostDescription>{post.content.substring(0, 50)}...</PostDescription>
                      <PostDetails>
                        <DetailItem>💬 {post.commentList.length}</DetailItem>
                        <DetailItem>❤️ {post.likeCount}</DetailItem>
                        {post.postImageUrls && post.postImageUrls.length > 0 && (
                          <DetailItem>📸 {post.postImageUrls.length}</DetailItem>
                        )}
                        <DetailItem>🕒 {new Date(post.createAt).toLocaleDateString()}</DetailItem>
                        
                      </PostDetails>
                    </PostInfo>
                    <PostScore>{index + 1}</PostScore>
                  </PostContent>
                </PostCard>
              ))}
            </PostList>
          </ContentWrapper>
        </MainContent>
      </PageContainer>
    </>
  );
};

export default Home;

// 홈 페이지에만 적용되는 스타일드 컴포넌트

// 서브타이틀 옆의 불꽃 아이콘
const FireIcon = styled.span`
  font-size: 34px;
  margin-right: 10px;
`;

// 포스트 리스트
const PostList = styled.div`
  width: 100%;
`;

// 각 포스트 카드에 표시되는 점수
const PostScore = styled.div`
  font-size: 24px;
  font-weight: bold;
  color: #ffca28;
`;

// 글쓰기 버튼
const WriteButton = styled.button`
  background-color: #ffca28;
  color: #fff;
  border: none;
  border-radius: 5px;
  padding: 10px 20px;
  font-size: 16px;
  font-weight: bold;
  cursor: pointer;
  margin-left: auto;

  &:hover {
    background-color: #ffb300;
  }
`;
