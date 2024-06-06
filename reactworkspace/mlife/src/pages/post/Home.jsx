import React, { useEffect, useState } from 'react';
import styled, { createGlobalStyle } from 'styled-components';
import { getPopulaPostsApi } from '../../api/PostApi';
import { useNavigate } from 'react-router-dom';
import logo from '../../assets/logo.png';
import { Category, getCategoryEmoji } from '../../components/category';

// 전체 페이지의 배경색을 설정하는 글로벌 스타일
const GlobalStyle = createGlobalStyle`
  body, html, #root {
    background-color: #fff;
  }
`;

const Home = () => {
  // posts 상태와 loading 상태를 선언
  const [posts, setPosts] = useState([]);
  const [loading, setLoading] = useState(true);
  const navigate = useNavigate();

  // 컴포넌트가 마운트될 때 인기 게시물을 로드하는 함수
  useEffect(() => {
    const loadPosts = async () => {
      try {
        const data = await getPopulaPostsApi();
        if (Array.isArray(data)) {
          setPosts(data); // 데이터를 posts 상태에 저장
        } else {
          setPosts([]);
        }
      } catch (error) {
        console.error(error);
        setPosts([]);
      } finally {
        setLoading(false); // 로딩 상태를 false로 설정
      }
    };

    loadPosts();
  }, []);

  // 로딩 중일 때 표시할 메시지
  if (loading) {
    return <LoadingMessage>로딩 중...</LoadingMessage>;
  }

  return (
    <>
      <GlobalStyle />
      <PageContainer>
        <MainContent>
          <Header>
            <LogoImage src={logo} alt="M-Life Logo" />
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
          <ContentWrapper>
            <SubHeader>
              <FireIcon>🔥</FireIcon>
              <SubTitle>Popular Posts 100</SubTitle>
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
        <MarginSection />
      </PageContainer>
    </>
  );
};

export default Home;

// 스타일드 컴포넌트

// 전체 페이지 컨테이너
const PageContainer = styled.div`
  display: flex; /* Flexbox를 사용하여 자식 요소를 정렬 */
  background-color: #f7f9fc; /* 배경색을 연한 회색으로 설정 */
  overflow: hidden; /* 내용이 넘칠 경우 숨김 */
  justify-content: space-between; /* 자식 요소를 좌우로 균등하게 배치 */
`;

// 여백 공간을 만드는 섹션
const MarginSection = styled.div`
  width: 50px; /* 여백 섹션의 너비를 50px로 설정 */
  flex-shrink: 0; /* 축소되지 않도록 설정 */
`;

// 메인 콘텐츠 영역
const MainContent = styled.div`
  flex: 1; /* 남은 공간을 모두 차지 */
  display: flex; /* Flexbox를 사용하여 자식 요소를 정렬 */
  flex-direction: column; /* 자식 요소를 세로로 배치 */
  align-items: center; /* 자식 요소를 수평 중앙 정렬 */
  overflow-y: auto; /* 세로 스크롤 허용 */
  margin: 0 20px; /* 좌우 여백 20px 설정 */
`;

// 페이지 헤더
const Header = styled.header`
  background-color: #fff; /* 배경색을 흰색으로 설정 */
  width: 100%; /* 가로 너비를 100%로 설정 */
  padding: 10px 20px; /* 상하 여백 10px, 좌우 여백 20px 설정 */
  display: flex; /* Flexbox를 사용하여 자식 요소를 정렬 */
  flex-direction: column; /* 자식 요소를 세로로 배치 */
  align-items: center; /* 자식 요소를 수평 중앙 정렬 */
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); /* 박스 그림자 설정 */
`;

// 로그인/회원가입 버튼을 위한 상단 내비게이션 바
const TopNav = styled.div`
  width: 100%; /* 가로 너비를 100%로 설정 */
  display: flex; /* Flexbox를 사용하여 자식 요소를 정렬 */
  justify-content: flex-end; /* 자식 요소를 오른쪽 끝으로 정렬 */
  margin-bottom: 10px; /* 아래 여백 10px 설정 */
`;

// 내비게이션 버튼 (로그인/회원가입)
const NavButton = styled.button`
  margin-left: 10px; /* 왼쪽 여백 10px 설정 */
  background-color: transparent; /* 배경색을 투명으로 설정 */
  border: 1px solid #000; /* 검은색 테두리 설정 */
  border-radius: 5px; /* 모서리를 둥글게 설정 */
  padding: 5px 10px; /* 상하 여백 5px, 좌우 여백 10px 설정 */
  color: #000; /* 글자색을 검은색으로 설정 */
  cursor: pointer; /* 마우스 커서를 포인터로 변경 */
  transition: background-color 0.3s, color 0.3s; /* 배경색과 글자색의 전환 효과 설정 */

  &:hover, &:focus {
    background-color: #ffca28; /* 배경색을 노란색으로 설정 */
    color: #fff; /* 글자색을 흰색으로 설정 */
  }
`;

// 페이지 상단의 로고 이미지
const LogoImage = styled.img`
  width: 100px; /* 너비를 100px로 설정 */
  height: auto; /* 높이를 자동으로 설정하여 비율 유지 */
  margin-bottom: 10px; /* 아래 여백 10px 설정 */
`;

// 카테고리용 내비게이션 바
const NavBar = styled.nav`
  display: flex; /* Flexbox를 사용하여 자식 요소를 정렬 */
  justify-content: center; /* 자식 요소를 수평 중앙 정렬 */
  flex-wrap: wrap; /* 자식 요소를 여러 줄로 배치 */
  width: 100%; /* 가로 너비를 100%로 설정 */
`;

// 각 카테고리의 개별 내비게이션 항목
const NavItem = styled.div`
  margin: 5px 10px; /* 위아래 여백 5px, 좌우 여백 10px 설정 */
  font-size: 16px; /* 글자 크기를 16px로 설정 */
  color: #333; /* 글자색을 어두운 회색으로 설정 */
  cursor: pointer; /* 마우스 커서를 포인터로 변경 */
  padding: 5px 10px; /* 상하 여백 5px, 좌우 여백 10px 설정 */
  text-align: center; /* 글자를 중앙 정렬 */
  border-radius: 8px; /* 모서리를 둥글게 설정 */
  transition: background-color 0.3s, color 0.3s; /* 배경색과 글자색의 전환 효과 설정 */
  background-color: #fff; /* 배경색을 흰색으로 설정 */

  &:hover, &.active {
    color: #fff; /* 글자색을 흰색으로 설정 */
    background-color: #ffca28; /* 배경색을 노란색으로 설정 */
  }
`;

// 카테고리 이름 옆에 표시되는 이모지
const Emoji = styled.span`
  margin-right: 5px; /* 오른쪽 여백 5px 설정 */
`;

// 메인 콘텐츠의 래퍼
const ContentWrapper = styled.div`
  flex: 1; /* 남은 공간을 모두 차지 */
  display: flex; /* Flexbox를 사용하여 자식 요소를 정렬 */
  flex-direction: column; /* 자식 요소를 세로로 배치 */
  align-items: center; /* 자식 요소를 수평 중앙 정렬 */
  width: 100%; /* 가로 너비를 100%로 설정 */
  padding: 20px; /* 여백을 20px 설정 */
  overflow-y: auto; /* 세로 스크롤 허용 */
`;

// 인기 포스트 섹션의 서브 헤더
const SubHeader = styled.div`
  display: flex; /* Flexbox를 사용하여 자식 요소를 정렬 */
  align-items: center; /* 자식 요소를 수직 중앙 정렬 */
  background-color: #ffca28; /* 배경색을 노란색으로 설정 */
  width: 100%; /* 가로 너비를 100%로 설정 */
  padding: 35px; /* 여백을 10px 설정 */
  border-bottom: 1px solid #ddd; /* 아래쪽 테두리를 회색으로 설정 */
  justify-content: center; /* 자식 요소를 수평 중앙 정렬 */
  margin-bottom: 20px; /* 아래 여백 20px 설정 */
  border-radius: 50px; /* 모서리를 둥글게 설정 */
`;

// 서브타이틀 옆의 불꽃 아이콘
const FireIcon = styled.span`
  font-size: 34px; /* 글자 크기를 24px로 설정 */
  margin-right: 10px; /* 오른쪽 여백 10px 설정 */
`;

// 인기 포스트 섹션의 서브타이틀
const SubTitle = styled.h2`
  font-size: 25px; /* 글자 크기를 20px로 설정 */
  color: #fff; /* 글자색을 흰색으로 설정 */
`;

// 포스트 리스트
const PostList = styled.div`
  width: 100%; /* 가로 너비를 100%로 설정 */
`;

// 각 포스트 카드
const PostCard = styled.div`
  display: flex; /* Flexbox를 사용하여 자식 요소를 정렬 */
  align-items: center; /* 자식 요소를 수직 중앙 정렬 */
  background-color: #fff; /* 배경색을 흰색으로 설정 */
  margin-bottom: 10px; /* 아래 여백 10px 설정 */
  padding: 10px; /* 여백을 10px 설정 */
  border-radius: 8px; /* 모서리를 둥글게 설정 */
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); /* 박스 그림자 설정 */
  cursor: pointer; /* 마우스 커서를 포인터로 변경 */
  transition: transform 0.2s; /* 크기 전환 효과 설정 */
  border-radius: 8px; /* 모서리를 둥글게 설정 */

  &:hover {
    transform: scale(1.02); /* 크기를 1.02배로 확대 */
  }
`;

// 각 포스트의 썸네일 이미지
const Thumbnail = styled.img`
  width: 80px; /* 너비를 80px로 설정 */
  height: 80px; /* 높이를 80px로 설정 */
  object-fit: cover; /* 이미지를 덮어씌우기 */
  border-radius: 8px; /* 모서리를 둥글게 설정 */
  margin-right: 10px; /* 오른쪽 여백 10px 설정 */
`;

// 각 포스트 카드의 콘텐츠 섹션
const PostContent = styled.div`
  display: flex; /* Flexbox를 사용하여 자식 요소를 정렬 */
  justify-content: space-between; /* 자식 요소를 좌우로 균등하게 배치 */
  align-items: center; /* 자식 요소를 수직 중앙 정렬 */
  width: 100%; /* 가로 너비를 100%로 설정 */
`;

// 각 포스트 카드의 정보 섹션
const PostInfo = styled.div`
  display: flex; /* Flexbox를 사용하여 자식 요소를 정렬 */
  flex-direction: column; /* 자식 요소를 세로로 배치 */
  text-align: left; /* 텍스트를 왼쪽 정렬 */
`;

// 포스트의 카테고리
const PostCategory = styled.span`
  font-size: 14px; /* 글자 크기를 14px로 설정 */
  color: #007bff; /* 글자색을 파란색으로 설정 */
  white-space: nowrap; /* 공백을 줄바꿈하지 않도록 설정 */
`;

// 포스트의 제목
const PostTitle = styled.h2`
  font-size: 20px; /* 글자 크기를 20px로 설정 */
  margin: 5px 0; /* 위아래 여백 5px 설정 */
  color: #333; /* 글자색을 어두운 회색으로 설정 */
  white-space: nowrap; /* 공백을 줄바꿈하지 않도록 설정 */
`;

// 포스트의 설명
const PostDescription = styled.p`
  font-size: 14px; /* 글자 크기를 14px로 설정 */
  color: #666; /* 글자색을 회색으로 설정 */
`;

// 각 포스트 카드의 세부 정보 섹션
const PostDetails = styled.div`
  display: flex; /* Flexbox를 사용하여 자식 요소를 정렬 */
  gap: 10px; /* 자식 요소 간 간격을 10px 설정 */
  margin-top: 5px; /* 위쪽 여백 5px 설정 */
  font-size: 14px; /* 글자 크기를 14px로 설정 */
  color: #999; /* 글자색을 연한 회색으로 설정 */
`;

// 포스트 세부 정보 내의 개별 항목
const DetailItem = styled.span``; // 별도 스타일 없음

// 각 포스트 카드에 표시되는 점수
const PostScore = styled.div`
  font-size: 24px; /* 글자 크기를 24px로 설정 */
  font-weight: bold; /* 글자 두께를 굵게 설정 */
  color: #ffca28; /* 글자색을 노란색으로 설정 */
`;

// 로딩 중 표시되는 메시지
const LoadingMessage = styled.div`
  font-size: 18px; /* 글자 크기를 18px로 설정 */
  color: #666; /* 글자색을 회색으로 설정 */
  margin-top: 50px; /* 위쪽 여백 50px 설정 */
  text-align: center; /* 텍스트를 중앙 정렬 */
`;
