import React, { useState } from 'react';
import styled from 'styled-components';
import logo from '../../assets/logo.png';
import { useNavigate } from 'react-router-dom';
import { postSignupApi } from '../../api/UserApi';

const SignupPage = () => {
  const navigate = useNavigate();
  const [formData, setFormData] = useState({
    username: '',
    password: '',
    nickname: '',
    email: ''
  });
  const [error, setError] = useState('');

  // 유효성 검사 함수
  const validateUsername = (username) => /^[a-zA-Z0-9]+$/.test(username); // 영어와 숫자만 허용
  const validatePassword = (password) => password.length >= 4 && password.length <= 10; // 4~10자
  const validateNickname = (nickname) => nickname.length >= 4; // 4글자 이상
  const validateEmail = (email) => /\S+@\S+\.\S+/.test(email); // 이메일 형식

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setFormData({ ...formData, [name]: value });
  };

  const handleSignup = async (e) => {
    e.preventDefault();

    const { username, password, nickname, email } = formData;

    if (!validateUsername(username)) {
      setError('아이디는 한글만 가능합니다.');
      return;
    }
    if (!validatePassword(password)) {
      setError('비밀번호는 4~10자 이내여야 합니다.');
      return;
    }
    if (!validateNickname(nickname)) {
      setError('닉네임은 4글자 이상이어야 합니다.');
      return;
    }
    if (!validateEmail(email)) {
      setError('유효한 이메일 형식을 입력해주세요.');
      return;
    }

    const userReqDto = {
      username,
      password,
      nickname,
      email
    };

    try {
      const response = await postSignupApi(userReqDto);
      if (response.status === 200) {
        window.alert('성공적으로 회원가입 되었습니다.');
        navigate('/login');
      }
    } catch (error) {
      console.log(error);
      if (error.response && error.response.status === 400) {
        window.alert(error.response.data);
      } else {
        window.alert('회원가입에 실패하였습니다. 다시 확인해주세요.');
      }
    }
  };

  return (
    <Container>
      <Logo src={logo} alt="Logo" />
      <Title>회원가입</Title>
      <Form onSubmit={handleSignup}>
        <Input
          type="text"
          name="username"
          placeholder="아이디 입력란"
          value={formData.username}
          onChange={handleInputChange}
        />
        <Input
          type="password"
          name="password"
          placeholder="비밀번호 입력란"
          value={formData.password}
          onChange={handleInputChange}
        />
        <Input
          type="text"
          name="nickname"
          placeholder="닉네임 입력란"
          value={formData.nickname}
          onChange={handleInputChange}
        />
        <Input
          type="email"
          name="email"
          placeholder="이메일 입력란"
          value={formData.email}
          onChange={handleInputChange}
        />
        <Button type="submit">회원가입</Button>
        {error && <ErrorMessage>{error}</ErrorMessage>}
        <TextButton onClick={() => navigate('/login')}>
          이미 <span style={{ color: '#ffca28' }}>로그인</span>이 되어 있나요?
        </TextButton>
      </Form>
    </Container>
  );
};

export default SignupPage;

const Container = styled.div`
  display: flex;
  flex-direction: column;
  align-items: center;
  padding-top: 100px;
  background-color: #f7f9fc;
  height: 100%;
  margin: 0 100px;
`;

const Logo = styled.img`
  width: 200px;
  height: auto;
  margin-bottom: 20px;
  background-color: white;
  padding: 10px;
  border-radius: 50%;
`;

const Title = styled.h1`
  font-size: 24px;
  margin-bottom: 20px;
  color: #333;
`;

const Form = styled.form`
  display: flex;
  flex-direction: column;
  align-items: center;
  width: 400px;
  background-color: #fff;
  padding: 20px;
  border-radius: 10px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
`;

const Input = styled.input`
  width: 100%;
  padding: 15px;
  margin: 10px 0;
  border: 1px solid #ddd;
  border-radius: 20px;
  color: #333;
  background-color: #fff;
  font-size: 16px;
  &:focus {
    border-color: #ffca28;
    outline: none;
  }
`;

const Button = styled.button`
  width: 100%;
  padding: 10px;
  margin-top: 20px;
  background-color: #ffca28;
  border: none;
  border-radius: 5px;
  color: white;
  font-weight: bold;
  cursor: pointer;
  &:hover {
    background-color: #ffb300;
  }
`;

const TextButton = styled.button`
  background: none;
  border: none;
  color: #ffca28;
  cursor: pointer;
  margin-top: 10px;
`;

const ErrorMessage = styled.div`
  color: red;
  margin-top: 10px;
`;
