import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import logo from '../../assets/logo.png';
import { getPopulaPostsApi } from '../../api/PostApi';
import { useAuth } from '../../security/AuthContext'; // AuthContext 사용
import { getUserProfileApi } from '../../api/UserApi'; // 프로필 API 가져오기
import ProfileModal from '../../components/ProfileModal'; // 프로필 모달 컴포넌트 가져오기
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

const Home = () => {
  const [posts, setPosts] = useState([]);
  const [loading, setLoading] = useState(true);
  const [showProfileModal, setShowProfileModal] = useState(false);
  const [profileData, setProfileData] = useState(null);
  const navigate = useNavigate();
  const { isAuthenticated } = useAuth(); // 현재 로그인 여부 확인

  useEffect(() => {
    const loadPosts = async () => {
      try {
        const data = await getPopulaPostsApi();
        if (Array.isArray(data)) {
          const postsWithAuthors = await Promise.all(data.map(async (post) => {
            try {
              const response = await getUserProfileApi(post.authorName);
              return { ...post, authorAvatar: response.data.profileImageUrl || logo, likeCount: post.likeCount };
            } catch (error) {
              return { ...post, authorAvatar: logo, likeCount: post.likeCount };
            }
          }));
          setPosts(postsWithAuthors);
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

  const handleAvatarClick = async (authorName) => {
    if (!isAuthenticated) {
      window.alert('로그인이 필요합니다.');
      return;
    }

    try {
      const response = await getUserProfileApi(authorName);
      const profile = response.data;
      const profileData = {
        username: authorName,
        profileImageUrl: profile.profileImageUrl || logo,
        introduction: profile.introduction,
        jobName: profile.jobName,
        experience: profile.experience,
        totalLikes: profile.totalLikes || 0 // 총 좋아요 개수 추가
      };
      setProfileData(profileData);
      setShowProfileModal(true);
    } catch (error) {
      console.error('Failed to load user profile:', error);
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
                <PostRow key={post.id}>
                  <PostCardContainer onClick={() => navigate(`/post/${post.id}`)}>
                    <PostCard>
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
                  </PostCardContainer>
                  <AuthorCard onClick={() => handleAvatarClick(post.authorName)}>
                    <AuthorAvatar src={post.authorAvatar} alt="author avatar" />
                    <AuthorName>{post.authorName}</AuthorName>
                    <Ranking>#{index + 1}</Ranking>
                  </AuthorCard>
                </PostRow>
              ))}
            </PostList>
          </ContentWrapper>
        </MainContent>
      </PageContainer>
      {showProfileModal && (
        <ProfileModal
          show={showProfileModal}
          onClose={() => setShowProfileModal(false)}
          profile={profileData}
        />
      )}
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

// 각 포스트 행 (게시글 + 프로필 카드)
const PostRow = styled.div`
  display: flex;
  margin-bottom: 20px;
  align-items: flex-start;
`;

// 게시글 카드 컨테이너
const PostCardContainer = styled.div`
  flex: 1;
`;

// 작성자 카드
const AuthorCard = styled.div`
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  width: 150px;
  height: 100%;
  padding: 10px;
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  margin-left: 20px;
  cursor: pointer; /* 클릭 가능하도록 커서 변경 */
`;

const AuthorAvatar = styled.img`
  width: 60px;
  height: 60px;
  border-radius: 50%;
  object-fit: cover;
  border: 2px solid #ffca28;
  margin-bottom: 10px;
`;

const AuthorName = styled.div`
  font-size: 14px;
  font-weight: bold;
  color: #333;
  text-align: center;
`;


const Ranking = styled.div`
  font-size: 18px;
  font-weight: bold;
  color: #ffca28;
  text-align: center;
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
