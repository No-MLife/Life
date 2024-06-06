import React, { useState } from 'react';
import styled from 'styled-components';
import logo from '../../assets/logo.png';
import { useNavigate } from 'react-router-dom';
import {postSignupApi} from '../../api/UserApi'


const SignupPage = () => {
  const navigate = useNavigate();
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [nickname, setNickname] = useState('');
  const [email, setEmail] = useState('');
  const [error, setError] = useState('');

  const handleSignup = async (e) => {
    e.preventDefault();
    // 회원가입 로직 구현
    const UserReqDto = {
        "username": username,
        "password": password,
        "nickname": nickname,
        "email": email
      }

    try {
      const response = await postSignupApi(UserReqDto);  
      // UserRepository의 signup 메소드를 호출하여 회원가입 요청 보내기
      console.log(response.status)
      if (response.status == 200) {
        window.alert("성공적으로 회원가입 되었습니다.");
        navigate('/login');
    } 
    } catch (error) {
      console.log(error)
      if(error.response.status == 400)
        window.alert(error.response.data);
      else
        window.alert("회원가입에 실패하였습니다. 다시 확인해주세요.");
    }

      
  };

  return (
    <Container>
      <Logo src={logo} alt="Logo" />
      <Title>회원가입</Title>
      <Form onSubmit={handleSignup}>
        <Input
          type="text"
          placeholder="아이디 입력란"
          value={username}
          onChange={(e) => setUsername(e.target.value)}
        />
        <Input
          type="password"
          placeholder="비밀번호 입력란"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
        />
        <Input
          type="text"
          placeholder="닉네임 입력란"
          value={nickname}
          onChange={(e) => setNickname(e.target.value)}
        />
        <Input
          type="email"
          placeholder="이메일 입력란"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
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
  width: 200px; // 로고 크기 증가
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
  border-radius: 20px; // 입력란 라운드 추가
  color: #333;
  background-color: #fff;
  font-size: 16px;
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
