import styled, { createGlobalStyle } from 'styled-components';

// 전체 페이지의 배경색을 설정하는 글로벌 스타일
export const GlobalStyle = createGlobalStyle`
  body, html, #root {
    background-color: #fff;
  }
`;

// 전체 페이지 컨테이너
export const PageContainer = styled.div`
  display: flex;
  background-color: #f7f9fc;
  overflow: hidden;
  justify-content: space-between;
`;

// 메인 콘텐츠 영역
export const MainContent = styled.div`
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  overflow-y: auto;
  margin: 0 20px;
`;

// 페이지 헤더
export const Header = styled.header`
  background-color: #fff;
  width: 100%;
  padding: 10px 20px;
  display: flex;
  flex-direction: column;
  align-items: center;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
`;

// 로그인/회원가입 버튼을 위한 상단 내비게이션 바
export const TopNav = styled.div`
  width: 100%;
  display: flex;
  justify-content: flex-end;
  margin-bottom: 10px;
`;

// 내비게이션 버튼 (로그인/회원가입)
export const NavButton = styled.button`
  margin-left: 10px;
  background-color: transparent;
  border: 1px solid #000;
  border-radius: 5px;
  padding: 5px 10px;
  color: #000;
  cursor: pointer;
  transition: background-color 0.3s, color 0.3s;

  &:hover, &:focus {
    background-color: #ffca28;
    color: #fff;
  }
`;

// 페이지 상단의 로고 이미지
export const LogoImage = styled.img`
  width: 100px;
  height: auto;
  margin-bottom: 10px;
  cursor: pointer; /* 클릭 가능하게 커서 변경 */
`;

// 카테고리용 내비게이션 바
export const NavBar = styled.nav`
  display: flex;
  justify-content: center;
  flex-wrap: wrap;
  width: 100%;
`;

// 각 카테고리의 개별 내비게이션 항목
export const NavItem = styled.div`
  margin: 5px 10px;
  font-size: 16px;
  color: #333;
  cursor: pointer;
  padding: 5px 10px;
  text-align: center;
  border-radius: 8px;
  transition: background-color 0.3s, color 0.3s;
  background-color: #fff;

  &:hover, &.active {
    color: #fff;
    background-color: #ffca28;
  }
`;


// 서브 헤더

export const SubHeader = styled.div`
  display: flex;
  align-items: center;
  background-color: #ffca28;
  width: 100%;
  padding: 15px;
  border-bottom: 1px solid #ddd;
  justify-content: center;
  margin-bottom: 20px;
  border-radius: 20px;
`;

// 서브타이틀
export const SubTitle = styled.h2`
  font-size: 25px;
  color: #fff;
`;


// 카테고리 이름 옆에 표시되는 이모지
export const Emoji = styled.span`
  margin-right: 5px;
`;

// 메인 콘텐츠의 래퍼
export const ContentWrapper = styled.div`
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  width: 100%;
  padding: 20px;
  overflow-y: auto;
`;

// 각 포스트 카드
export const PostCard = styled.div`
  display: flex;
  align-items: center;
  background-color: #fff;
  margin-bottom: 10px;
  padding: 10px;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  cursor: pointer;
  transition: transform 0.2s;

  &:hover {
    transform: scale(1.02);
  }
`;

// 각 포스트의 썸네일 이미지
export const Thumbnail = styled.img`
  width: 80px;
  height: 80px;
  object-fit: cover;
  border-radius: 8px;
  margin-right: 10px;
`;

// 각 포스트 카드의 콘텐츠 섹션
export const PostContent = styled.div`
  display: flex;
  justify-content: space-between;
  align-items: center;
  width: 100%;
`;

// 각 포스트 카드의 정보 섹션
export const PostInfo = styled.div`
  display: flex;
  flex-direction: column;
  text-align: left;
`;

// 포스트의 카테고리
export const PostCategory = styled.span`
  font-size: 14px;
  color: #007bff;
  white-space: nowrap;
`;

// 포스트의 제목
export const PostTitle = styled.h2`
  font-size: 20px;
  margin: 5px 0;
  color: #333;
  white-space: nowrap;
`;

// 포스트의 설명
export const PostDescription = styled.p`
  font-size: 14px;
  color: #666;
`;

// 각 포스트 카드의 세부 정보 섹션
export const PostDetails = styled.div`
  display: flex;
  gap: 10px;
  margin-top: 5px;
  font-size: 14px;
  color: #999;
`;

// 포스트 세부 정보 내의 개별 항목
export const DetailItem = styled.span``;

// 로딩 중 표시되는 메시지
export const LoadingMessage = styled.div`
  font-size: 18px;
  color: #666;
  margin-top: 50px;
  text-align: center;
`;
