import React, { useState } from 'react';
import styled from 'styled-components';
import logo from '../../assets/logo.png';
import { useAuth } from '../../security/AuthContext';
import { useNavigate } from 'react-router-dom';



const LoginPage = () => {
  const authContext = useAuth();
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const auth = useAuth();
  const navigate = useNavigate();

  const handleLogin = async (e) => {
    e.preventDefault();
    // 여기에 실제 로그인 로직 추가

    const UserReqDto = {
      "username": username,
      "password": password
    }
    try {
      console.log("로그인 요청");
      const success = await authContext.login(UserReqDto);
      if (success) {
        console.log(auth.username, auth.token);
        window.alert("로그인 되었습니다.");
        navigate('/');
      } else {
        window.alert("아이디 또는 비밀번호가 일치하지 않습니다.");
      }
    } catch (error) {
      setError(error)
      window.alert(error);
    }
  };

  return (
    <Container>
      <Logo src={logo} alt="Logo" />
      <Title>로그인</Title>
      <Form onSubmit={handleLogin}>
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
        <Button type="submit">로그인</Button>
        {error && <ErrorMessage>{error}</ErrorMessage>}
        <TextButton onClick={() => navigate('/signup')}>
          아직 <span style={{ color: '#ffca28' }}>회원가입</span>이 되어 있지 않나요?
        </TextButton>
      </Form>
    </Container>
  );
};

export default LoginPage;


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