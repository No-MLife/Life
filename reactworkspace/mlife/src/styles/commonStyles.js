import styled, { createGlobalStyle } from 'styled-components';

// 전체 페이지의 배경색을 설정하는 글로벌 스타일
export const GlobalStyle = createGlobalStyle`
  body, html, #root {
    background-color: #fff; // 전체 페이지의 배경색을 흰색으로 설정
  }
`;

// 전체 페이지 컨테이너
export const PageContainer = styled.div`
  display: flex; // 페이지를 플렉스 박스로 설정
  background-color: #f7f9fc; // 페이지 배경색을 연한 회색으로 설정
  overflow: hidden; // 넘치는 콘텐츠를 숨김
  justify-content: space-between; // 자식 요소들을 양 끝으로 정렬
`;

// 메인 콘텐츠 영역
export const MainContent = styled.div`
  flex: 1; // 메인 콘텐츠 영역이 가능한 모든 공간을 차지하도록 설정
  display: flex; // 플렉스 박스로 설정
  flex-direction: column; // 자식 요소들을 세로로 정렬
  align-items: center; // 자식 요소들을 중앙으로 정렬
  overflow-y: auto; // 세로로 넘치는 콘텐츠는 스크롤 가능하도록 설정
  margin: 0 20px; // 좌우 여백을 20px로 설정
`;

// 페이지 헤더
export const Header = styled.header`
  background-color: #fff; // 헤더 배경색을 흰색으로 설정
  width: 100%; // 헤더 너비를 100%로 설정
  padding: 10px 20px; // 헤더 패딩을 위아래 10px, 좌우 20px로 설정
  display: flex; // 플렉스 박스로 설정
  flex-direction: column; // 자식 요소들을 세로로 정렬
  align-items: center; // 자식 요소들을 중앙으로 정렬
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); // 그림자를 추가하여 입체감 부여
`;

// 로그인/회원가입 버튼을 위한 상단 내비게이션 바
export const TopNav = styled.div`
  width: 100%; // 너비를 100%로 설정
  display: flex; // 플렉스 박스로 설정
  justify-content: flex-end; // 자식 요소들을 오른쪽 끝으로 정렬
  margin-bottom: 10px; // 아래 여백을 10px로 설정
`;

// 내비게이션 버튼 (로그인/회원가입)
export const NavButton = styled.button`
  margin-left: 10px; // 왼쪽 여백을 10px로 설정
  background-color: transparent; // 배경색을 투명하게 설정
  border: 1px solid #000; // 검은색 실선 테두리를 설정
  border-radius: 5px; // 테두리를 둥글게 설정
  padding: 5px 10px; // 패딩을 위아래 5px, 좌우 10px로 설정
  color: #000; // 글자 색상을 검은색으로 설정
  cursor: pointer; // 마우스를 올렸을 때 커서를 포인터로 변경
  transition: background-color 0.3s, color 0.3s; // 배경색과 글자 색상 변화에 애니메이션 추가

  &:hover, &:focus {
    background-color: #ffca28; // 배경색을 노란색으로 변경
    color: #fff; // 글자 색상을 흰색으로 변경
  }
`;

// 페이지 상단의 로고 이미지
export const LogoImage = styled.img`
  width: 100px; // 너비를 100px로 설정
  height: auto; // 높이를 자동으로 설정하여 원본 비율 유지
  margin-bottom: 10px; // 아래 여백을 10px로 설정
  cursor: pointer; // 클릭 가능하게 커서 변경
`;

// 카테고리용 내비게이션 바
export const NavBar = styled.nav`
  display: flex; // 플렉스 박스로 설정
  justify-content: center; // 자식 요소들을 중앙으로 정렬
  flex-wrap: wrap; // 자식 요소들이 여러 줄로 나뉘도록 설정
  width: 100%; // 너비를 100%로 설정
`;

// 각 카테고리의 개별 내비게이션 항목
export const NavItem = styled.div`
  margin: 5px 10px; // 위아래 여백을 5px, 좌우 여백을 10px로 설정
  font-size: 16px; // 글자 크기를 16px로 설정
  color: #333; // 글자 색상을 짙은 회색으로 설정
  cursor: pointer; // 클릭 가능하게 커서 변경
  padding: 5px 10px; // 패딩을 위아래 5px, 좌우 10px로 설정
  text-align: center; // 글자 중앙 정렬
  border-radius: 8px; // 테두리를 둥글게 설정
  transition: background-color 0.3s, color 0.3s; // 배경색과 글자 색상 변화에 애니메이션 추가
  background-color: #fff; // 배경색을 흰색으로 설정

  &:hover, &.active {
    color: #fff; // 글자 색상을 흰색으로 변경
    background-color: #ffca28; // 배경색을 노란색으로 변경
  }
`;

// 서브 헤더
export const SubHeader = styled.div`
  display: flex; // 플렉스 박스로 설정
  align-items: center; // 자식 요소들을 중앙으로 정렬
  background-color: #ffca28; // 배경색을 노란색으로 설정
  width: 100%; // 너비를 100%로 설정
  padding: 15px; // 패딩을 15px로 설정
  border-bottom: 1px solid #ddd; // 아래 테두리를 회색 실선으로 설정
  justify-content: center; // 자식 요소들을 중앙으로 정렬
  margin-bottom: 20px; // 아래 여백을 20px로 설정
  border-radius: 20px; // 테두리를 둥글게 설정
`;

// 서브타이틀
export const SubTitle = styled.h2`
  font-size: 25px; // 글자 크기를 25px로 설정
  color: #fff; // 글자 색상을 흰색으로 설정
`;

// 카테고리 이름 옆에 표시되는 이모지
export const Emoji = styled.span`
  margin-right: 5px; // 오른쪽 여백을 5px로 설정
`;

// 메인 콘텐츠의 래퍼
export const ContentWrapper = styled.div`
  flex: 1; // 가능한 모든 공간을 차지하도록 설정
  display: flex; // 플렉스 박스로 설정
  flex-direction: column; // 자식 요소들을 세로로 정렬
  align-items: center; // 자식 요소들을 중앙으로 정렬
  width: 100%; // 너비를 100%로 설정
  padding: 20px; // 패딩을 20px로 설정
  overflow-y: auto; // 세로로 넘치는 콘텐츠는 스크롤 가능하도록 설정
`;

// 각 포스트 카드
export const PostCard = styled.div`
  display: flex; // 플렉스 박스로 설정
  align-items: center; // 자식 요소들을 중앙으로 정렬
  background-color: #fff; // 배경색을 흰색으로 설정
  margin-bottom: 10px; // 아래 여백을 10px로 설정
  padding: 10px; // 패딩을 10px로 설정
  border-radius: 8px; // 테두리를 둥글게 설정
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); // 그림자를 추가하여 입체감 부여
  cursor: pointer; // 클릭 가능하게 커서 변경
  transition: transform 0.2s; // 크기 변화에 애니메이션 추가

  &:hover {
    transform: scale(1.02); // 마우스를 올렸을 때 크기를 1.02배로 확대
  }
`;

// 각 포스트의 썸네일 이미지
export const Thumbnail = styled.img`
  width: 80px; // 너비를 80px로 설정
  height: 80px; // 높이를 80px로 설정
  object-fit: cover; // 이미지가 요소의 크기에 맞게 잘리거나 늘어남
  border-radius: 8px; // 테두리를 둥글게 설정
  margin-right: 10px; // 오른쪽 여백을 10px로 설정
`;

// 각 포스트 카드의 콘텐츠 섹션
export const PostContent = styled.div`
  display: flex; // 플렉스 박스로 설정
  justify-content: space-between; // 자식 요소들을 양 끝으로 정렬
  align-items: center; // 자식 요소들을 중앙으로 정렬
  width: 100%; // 너비를 100%로 설정
`;

// 각 포스트 카드의 정보 섹션
export const PostInfo = styled.div`
  display: flex; // 플렉스 박스로 설정
  flex-direction: column; // 자식 요소들을 세로로 정렬
  text-align: left; // 텍스트를 왼쪽으로 정렬
`;

// 포스트의 카테고리
export const PostCategory = styled.span`
  font-size: 14px; // 글자 크기를 14px로 설정
  color: #007bff; // 글자 색상을 파란색으로 설정
  white-space: nowrap; // 텍스트가 줄 바꿈되지 않도록 설정
`;

// 포스트의 제목
export const PostTitle = styled.h2`
  font-size: 20px; // 글자 크기를 20px로 설정
  margin: 5px 0; // 위아래 여백을 5px로 설정
  color: #333; // 글자 색상을 짙은 회색으로 설정
  white-space: nowrap; // 텍스트가 줄 바꿈되지 않도록 설정
`;

// 포스트의 설명
export const PostDescription = styled.p`
  font-size: 14px; // 글자 크기를 14px로 설정
  color: #666; // 글자 색상을 회색으로 설정
`;

// 각 포스트 카드의 세부 정보 섹션
export const PostDetails = styled.div`
  display: flex; // 플렉스 박스로 설정
  gap: 10px; // 자식 요소들 사이의 간격을 10px로 설정
  margin-top: 5px; // 위쪽 여백을 5px로 설정
  font-size: 14px; // 글자 크기를 14px로 설정
  color: #999; // 글자 색상을 연한 회색으로 설정
`;

// 포스트 세부 정보 내의 개별 항목
export const DetailItem = styled.span``; // 개별 항목 스타일 (추후 스타일 추가 가능)

// 로딩 중 표시되는 메시지
export const LoadingMessage = styled.div`
  font-size: 18px; // 글자 크기를 18px로 설정
  color: #666; // 글자 색상을 회색으로 설정
  margin-top: 50px; // 위쪽 여백을 50px로 설정
  text-align: center; // 텍스트를 중앙으로 정렬
`;
