import { createContext, useContext, useState, useEffect } from 'react';
import {jwtDecode} from 'jwt-decode';
import { postAuthLoginApi, postRefreshTokenApi } from '../api/UserApi';
import { setAuthToken, setupInterceptors } from '../api/ApiClient';

import backendUrl from '../config.js';
export const AuthContext = createContext();
export const useAuth = () => useContext(AuthContext);

export default function AuthProvider({ children }) {
  const [isAuthenticated, setAuthenticated] = useState(false);
  const [username, setUsername] = useState(null);
  const [token, setToken] = useState(null);

  useEffect(() => {
    const savedToken = localStorage.getItem('token');
    if (savedToken) {
      console.log(backendUrl)
      console.log("저장된 토큰 사용")
      setToken(savedToken);
      setAuthenticated(true);
      const decodedToken = jwtDecode(savedToken);
      setUsername(decodedToken.nickname);
      setAuthToken(savedToken);  // 토큰 설정
      setupInterceptors(savedToken, setToken, logout); // 인터셉터 설정
    }else{
      console.log("저장된 토큰이 없습니다.")
      logout();
    }
  }, []);

  useEffect(() => {
    if (token) {
      localStorage.setItem('token', token);
      setAuthToken(token);  // 토큰 설정
    } else {
      localStorage.removeItem('token');
      setAuthToken(null);  // 토큰 제거
    }
  }, [token]);

  useEffect(() => {
    if (token) {
      const decodedToken = jwtDecode(token);
      const exp = decodedToken.exp * 1000;
      const timeout = exp - Date.now() - 60000;

      const timer = setTimeout(() => {
        refreshAuthToken();
      }, timeout);

      return () => clearTimeout(timer);
    }
  }, [token]);

  async function login(UserReqDto) {
    try {
      const response = await postAuthLoginApi(UserReqDto);
      if (response.status === 200) {
        console.log('로그인 성공');
        const token = response.headers['access'];
        if (token) {
          setToken(token);
          setAuthenticated(true);

          const decodedToken = jwtDecode(token);
          const nickname = decodedToken.nickname;
          setUsername(nickname);
          setAuthToken(token);  // 토큰 설정
          setupInterceptors(token, setToken, logout); // 인터셉터 설정
          return true;
        }
      } else {
        logout();
        return false;
      }
    } catch (error) {
      console.log(error);
      logout();
      return false;
    }
  }

  function logout() {
    setAuthenticated(false);
    setToken(null);
    setUsername(null);
    setAuthToken(null);  // 토큰 제거
  }

  async function refreshAuthToken() {
    try {
      const response = await postRefreshTokenApi();
      if (response.status === 200) {
        const newToken = response.headers['access'];
        setToken(newToken);
        setAuthenticated(true);
        setAuthToken(newToken);
      } else {
        logout();
      }
    } catch (error) {
      console.log(error);
      logout();
    }
  }

  const value = {
    isAuthenticated,
    login,
    logout,
    username,
    token,
    setToken
  };

  return (
    <AuthContext.Provider value={value}>{children}</AuthContext.Provider>
  );
}
