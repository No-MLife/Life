import { createContext, useContext, useState } from 'react';
import { jwtDecode } from "jwt-decode";
import { postAuthLoginApi } from '../api/UserApi';
import { apiClient } from '../api/ApiClient';
import Cookies from 'js-cookie';

// 1: 문맥 생성
export const AuthContext = createContext();
export const useAuth = () => useContext(AuthContext);

const getCookieValue = () => {
  const cookieValue = Cookies.get('refresh');
  console.log(cookieValue);
  return cookieValue;
};

// 2: 다른 컴포넌트와 공유할 문맥 설정
export default function AuthProvider({ children }) {
  // 3: Put some state in the context
  const [isAuthenticated, setAuthenticated] = useState(false);
  const [username, setUsername] = useState(null);
  const [token, setToken] = useState(null);
  const [refreshToken, setRefreshToken] = useState(null);

  async function login(UserReqDto) {
    try {
      const response = await postAuthLoginApi(UserReqDto);
      if (response.status === 200) {
        console.log('로그인 성공');
        const token = response.headers['access'];
        // const refresh = getCookieValue();
        if (token) {
          setToken(token);
          // setRefreshToken(refreshToken);
          setAuthenticated(true);
          
          // JWT 디코드하여 nickname 추출
          const decodedToken = jwtDecode(token);
          const nickname = decodedToken.nickname;
          setUsername(nickname);

          apiClient.interceptors.request.use((config) => {
            console.log('요청 인터셉트');
            config.headers['access'] = token;
            return config;
          });
          return true;
        }
      } else {
        logout();
        return false;
      }
    } catch (error) {
      logout();
      return false;
    }
  }

  function logout() {
    setAuthenticated(false);
    setToken(null);
    setUsername(null);
  }

  const value = {
    isAuthenticated,
    login,
    logout,
    username,
    token,
  };

  return (
    // value
    <AuthContext.Provider value={value}>{children}</AuthContext.Provider>
  );
}
