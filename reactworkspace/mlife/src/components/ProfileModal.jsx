import React from 'react';
import styled from 'styled-components';
import logo from '../assets/logo.png';

const careerOptions = {
  'ZERO_YEAR': '0년',
  'ONE_TO_TWO_YEARS': '1~2년 이하',
  'THREE_TO_FIVE_YEARS': '3~5년',
  'OVER_SIX_YEARS': '6년 이상'
};

const getPosition = (career) => {
  switch (career) {
    case '0년':
      return '잡부';
    case '1~2년 이하':
      return '기능공';
    case '3~5년':
      return '기술자';
    case '6년 이상':
      return '현장소장';
    default:
      return '';
  }
};

const ProfileModal = ({ show, onClose, profile }) => {
  if (!show) {
    return null;
  }

  return (
    <Overlay onClick={onClose}>
      <ModalContainer onClick={(e) => e.stopPropagation()}>
        <CloseButton onClick={onClose}>×</CloseButton>
        <ProfileImage src={profile.profileImageUrl || logo} alt="Profile" />
        <ProfileInfo>
          <ProfileName>{profile.username}</ProfileName>
          <ProfileBio>{profile.introduction}</ProfileBio>
          <ProfileDetails>
            <DetailItem><strong>직업:</strong> {profile.jobName}</DetailItem>
            <DetailItem><strong>경력:</strong> {careerOptions[profile.experience]}</DetailItem>
            <DetailItem><strong>직책:</strong> {getPosition(careerOptions[profile.experience])}</DetailItem>
          </ProfileDetails>
        </ProfileInfo>
      </ModalContainer>
    </Overlay>
  );
};

export default ProfileModal;

const Overlay = styled.div`
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.7);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
`;

const ModalContainer = styled.div`
  background: white;
  border-radius: 10px;
  padding: 30px;
  position: relative;
  max-width: 500px;
  width: 100%;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
`;

const CloseButton = styled.button`
  position: absolute;
  top: 10px;
  right: 10px;
  background: none;
  border: none;
  font-size: 24px;
  cursor: pointer;
  color: #333;
`;

const ProfileImage = styled.img`
  width: 120px;
  height: 120px;
  border-radius: 50%;
  object-fit: cover;
  margin-bottom: 20px;
  border: 3px solid #ffca28; /* 노란색 테두리 추가 */
`;

const ProfileInfo = styled.div`
  text-align: center;
`;

const ProfileName = styled.h2`
  font-size: 24px;
  margin-bottom: 10px;
  color: #333;
`;

const ProfileBio = styled.p`
  font-size: 16px;
  color: #666;
  margin-bottom: 20px;
`;

const ProfileDetails = styled.div`
  text-align: left;
  color: #444;
`;

const DetailItem = styled.div`
  font-size: 16px;
  margin-bottom: 10px;
`;
