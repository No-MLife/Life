import React, { useEffect, useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import logo from '../../assets/logo.png';
import { Category, getCategoryEmoji } from '../../components/Category';
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
import { getPostsByCategoryApi } from '../../api/PostApi'; // 새 API 함수로 일반화
import { useAuth } from '../../security/AuthContext'; // AuthContext 사용

const CategoryPage = () => {
  const { categoryId } = useParams(); // URL 파라미터에서 카테고리 ID를 가져옴
  const [posts, setPosts] = useState([]);
  const [loading, setLoading] = useState(true);
  const navigate = useNavigate();
  const { isAuthenticated } = useAuth(); // 현재 로그인 여부 확인

  useEffect(() => {
    const loadPosts = async () => {
      try {
        const data = await getPostsByCategoryApi(categoryId);
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
  }, [categoryId]);

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

  const category = Object.values(Category).find(cat => cat.id.toString() === categoryId);

  return (
    <>
      <GlobalStyle />
      <PageContainer>
        <MainContent>
          <ContentWrapper>
            <SubHeader>
              <SubTitle>{getCategoryEmoji(category)} {category.name}</SubTitle>
              <WriteButton onClick={handleWriteButtonClick}>✏️ 글쓰기</WriteButton>
            </SubHeader>
            <PostList>
              {posts.map((post) => (
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

export default CategoryPage;

// 포스트 리스트
const PostList = styled.div`
  width: 100%;
  overflow: hidden
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
