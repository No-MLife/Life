import React, { useState, useEffect } from 'react';
import styled, { createGlobalStyle } from 'styled-components';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../../security/AuthContext';
import {
  getUserProfileApi,
  updateUserProfileApi,
  uploadProfileImageApi,
} from '../../api/UserApi';
import logo from '../../assets/logo.png';

// 글로벌 스타일 설정
const GlobalStyle = createGlobalStyle`
  body, html, #root {
    background-color: #fff; // 전체 페이지의 배경색을 흰색으로 설정
  }
`;

const UserProfilePage = () => {
  const { isAuthenticated, username } = useAuth();
  const navigate = useNavigate();
  const [profile, setProfile] = useState(null);
  const [bio, setBio] = useState('');
  const [selectedJob, setSelectedJob] = useState('');
  const [selectedCareer, setSelectedCareer] = useState('');
  const [selectedPosition, setSelectedPosition] = useState('');
  const [selectedImage, setSelectedImage] = useState(null);
  const [imagePreview, setImagePreview] = useState(logo);
  const [totalLikes, setTotalLikes] = useState(0); // 추가된 상태

  const jobOptions = ['철근공', '목수', '콘크리트공', '용접공', '설비공', '전기공', '기타'];
  const careerOptions = {
    'ZERO_YEAR': '0년',
    'ONE_TO_TWO_YEARS': '1~2년 이하',
    'THREE_TO_FIVE_YEARS': '3~5년',
    'OVER_SIX_YEARS': '6년 이상'
  };

  useEffect(() => {
    const fetchProfile = async () => {
      try {
        if (isAuthenticated) {
          const response = await getUserProfileApi(username);
          const profileData = response.data;
          setProfile(profileData);
          setBio(profileData.introduction);
          setSelectedJob(profileData.jobName);
          setSelectedCareer(careerOptions[profileData.experience]);
          setImagePreview(profileData.profileImageUrl || logo);
          setTotalLikes(profileData.totalLikes); // 추가된 부분
          updatePosition(careerOptions[profileData.experience]);
        } else {
          navigate('/login');
        }
      } catch (error) {
        console.error('Failed to fetch profile:', error);
      }
    };
    fetchProfile();
  }, [isAuthenticated, navigate, username]);

  const updatePosition = (career) => {
    switch (career) {
      case '0년':
        setSelectedPosition('잡부');
        break;
      case '1~2년 이하':
        setSelectedPosition('기능공');
        break;
      case '3~5년':
        setSelectedPosition('기술자');
        break;
      case '6년 이상':
        setSelectedPosition('현장소장');
        break;
      default:
        setSelectedPosition('');
    }
  };

  const handleImageChange = async (event) => {
    const file = event.target.files[0];
    if (file) {
      const formData = new FormData();
      formData.append('image', file);

      try {
        const response = await uploadProfileImageApi(username, formData);
        const newImageUrl = response.data.profileImageUrl;
        setSelectedImage(file);
        setImagePreview(URL.createObjectURL(file)); // 파일 객체를 URL로 변환하여 미리보기 설정
      } catch (error) {
        console.error('Failed to upload image:', error);
      }
    }
  };

  const handleSave = async (event) => {
    event.preventDefault();

    const profileData = {
      profileImageUrl: imagePreview,
      introduction: bio,
      jobName: selectedJob,
      experience: Object.keys(careerOptions).find(key => careerOptions[key] === selectedCareer),
    };

    try {
      await updateUserProfileApi(username, profileData);
      window.alert('프로필이 성공적으로 업데이트되었습니다.');
    } catch (error) {
      console.error('Failed to update profile:', error);
    }
  };

  return (
    <>
      <GlobalStyle />
      <Container>
        <Title>프로필 설정</Title>
        <SubTitle>나중에 언제든지 변경할 수 있습니다</SubTitle>
        <ProfileImageContainer>
          <ProfileImageWrapper>
            <ProfileImage src={imagePreview} alt="Profile" />
            <ImageInputLabel htmlFor="imageUpload">📷 사진 변경</ImageInputLabel>
            <LikesLabel>❤️ : {totalLikes}</LikesLabel>
            <ImageInput id="imageUpload" type="file" accept="image/*" onChange={handleImageChange} />
          </ProfileImageWrapper>
        </ProfileImageContainer>
        <Form onSubmit={handleSave}>
          <Label>사용자 이름</Label>
          <ReadOnlyInput type="text" value={username || ''} readOnly />
          <Label>한 줄 자기 소개</Label>
          <Input type="text" value={bio || ''} onChange={(e) => setBio(e.target.value)} />
          <Label>직업</Label>
          <Select value={selectedJob || ''} onChange={(e) => setSelectedJob(e.target.value)}>
            <option value="" disabled>직업을 선택하세요</option>
            {jobOptions.map((job) => (
              <option key={job} value={job}>
                {job}
              </option>
            ))}
          </Select>
          <Label>경력</Label>
          <Select
            value={selectedCareer || ''}
            onChange={(e) => {
              setSelectedCareer(e.target.value);
              updatePosition(e.target.value);
            }}
          >
            <option value="" disabled>경력을 선택하세요</option>
            {Object.values(careerOptions).map((career) => (
              <option key={career} value={career}>
                {career}
              </option>
            ))}
          </Select>
          <Label>직책</Label>
          <ReadOnlyInput type="text" value={selectedPosition || ''} readOnly />
          
          <Button type="submit">저장하기</Button>
        </Form>
      </Container>
    </>
  );
};

export default UserProfilePage;

const Container = styled.div`
  display: flex;
  flex-direction: column;
  align-items: center;
  padding-top: 50px;
  background-color: #fff;
  min-height: 100vh;
  margin: 0 100px;
`;

const Title = styled.h1`
  font-size: 24px;
  margin-bottom: 10px;
  color: #333;
`;

const SubTitle = styled.p`
  font-size: 16px;
  text-align: center;
  color: #666;
  margin-bottom: 20px;
`;

const ProfileImageContainer = styled.div`
  display: flex;
  align-items: center;
  margin-bottom: 20px;
`;

const ProfileImageWrapper = styled.div`
  display: flex;
  flex-direction: column;
 	align-items: center;
`;

const ProfileImage = styled.img`
  width: 150px;
  height: 150px;
  border-radius: 50%;
  object-fit: cover;
  background-color: white;
  padding: 10px;
  margin-bottom: 10px;
`;

const ImageInputLabel = styled.label`
  background-color: #fff;
  color: #333;
  border: 1px solid #ddd;
  border-radius: 20px;
  padding: 5px 10px;
  cursor: pointer;
  font-size: 14px;
  transition: background-color 0.3s, border-color 0.3s, color 0.3s;

  &:hover, &:focus {
    background-color: #ffca28;
    border-color: #ffca28;
    color: #fff;
  }
`;

const ImageInput = styled.input`
  display: none;
`;

const Form = styled.form`
  display: flex;
  flex-direction: column;
  align-items: center;
  width: 100%;
  max-width: 400px;
  background-color: #fff;
  padding: 20px;
  border-radius: 10px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
`;

const Label = styled.label`
  font-size: 14px;
  color: #333;
  margin-bottom: 4px;
  width: 100%;
`;

const Input = styled.input`
  width: 100%;
  padding: 15px;
  margin: 10px 0;
  border: 1px solid #ddd;
  border-radius: 20px;
  background-color: #fff;
  font-size: 16px;
  color: #333;
  transition: border-color 0.3s;
  &:focus {
    border-color: #ffca28;
    outline: none;
  }
`;

const ReadOnlyInput = styled(Input)`
  background-color: #f0f0f0;
  color: #666;
  cursor: not-allowed;
`;

const Select = styled.select`
  width: 100%;
  padding: 15px;
  margin: 10px 0;
  border: 1px solid #ddd;
  border-radius: 20px;
  background-color: #fff;
  font-size: 16px;
  color: #333;
  transition: border-color 0.3s;
  &:focus {
    border-color: #ffca28;
    outline: none;
  }
`;

const Button = styled.button`
  width: 100%;
  padding: 15px;
  margin-top: 20px;
  background-color: #ffca28;
  border: none;
  border-radius: 20px;
  color: white;
  font-weight: bold;
  font-size: 16px;
  cursor: pointer;

  &:hover {
    background-color: #ffb300;
  }
`;

const LikesLabel = styled.div`
  font-size: 16px;
  color: #333;
  margin-top: 10px;
`;