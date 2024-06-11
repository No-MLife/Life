import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../security/AuthContext';
import styled from 'styled-components';
import logo from '../assets/logo.png';
import {
  Header as StyledHeader,
  TopNav,
  NavButton,
  LogoImage,
  NavBar,
  NavItem,
  Emoji
} from '../styles/commonStyles';
import { Category, getCategoryEmoji } from './Category';
import Modal from './Modal'; // 모달 컴포넌트 가져오기

const Header = () => {
  const { isAuthenticated, logout } = useAuth();
  const navigate = useNavigate();
  const [showLogoutModal, setShowLogoutModal] = useState(false);

  const handleLogout = () => {
    setShowLogoutModal(true);
  };

  const confirmLogout = () => {
    logout();
    setShowLogoutModal(false);
    navigate('/');
  };

  const cancelLogout = () => {
    setShowLogoutModal(false);
  };

  return (
    <StyledHeader>
      <LogoImage src={logo} alt="M-Life Logo" onClick={() => navigate('/')} />
      <TopNav>
        {isAuthenticated ? (
          <>
            <NavButton onClick={handleLogout}>로그아웃</NavButton>
            <NavButton onClick={() => navigate('/user/profile')}>내정보</NavButton>
          </>
        ) : (
          <>
            <NavButton onClick={() => navigate('/login')}>로그인</NavButton>
            <NavButton onClick={() => navigate('/signup')}>회원가입</NavButton>
          </>
        )}
      </TopNav>
      <NavBar>
        {Object.values(Category).map((category) => (
          <NavItem key={category.id} onClick={() => navigate(`/${category.id}`)}>
            <Emoji>{getCategoryEmoji(category)}</Emoji> {category.name}
          </NavItem>
        ))}
      </NavBar>
      <Modal
        show={showLogoutModal}
        onClose={cancelLogout}
        onConfirm={confirmLogout}
        message="로그아웃 하시겠습니까?"
      />
    </StyledHeader>
  );
};

export default Header;
