import { createContext, useContext, useState, useEffect } from 'react';
import {jwtDecode} from 'jwt-decode';
import { postAuthLoginApi, postRefreshTokenApi } from '../api/UserApi';
import { apiClient } from '../api/ApiClient';

// 1: 문맥 생성
export const AuthContext = createContext();
export const useAuth = () => useContext(AuthContext);

// 2: 다른 컴포넌트와 공유할 문맥 설정
export default function AuthProvider({ children }) {
  // 3: Put some state in the context
  const [isAuthenticated, setAuthenticated] = useState(false);
  const [username, setUsername] = useState(null);
  const [token, setToken] = useState(null);

  useEffect(() => {
    const interval = setInterval(() => {
      if (token) {
        const decodedToken = jwtDecode(token);
        const currentTime = Math.floor(Date.now() / 1000);
        const timeLeft = decodedToken.exp - currentTime;
        if (timeLeft < 60) {
          refreshAccessToken();
        }
      }
    }, 30000); // 30초마다 체크

    return () => clearInterval(interval);
  }, [token]);

  const refreshAccessToken = async () => {
    try {
      const response = await postRefreshTokenApi();
      if (response.status === 200) {
        const newAccessToken = response.headers['access'];
        setToken(newAccessToken);
        apiClient.defaults.headers.common['access'] = newAccessToken;
        return newAccessToken;
      } else {
        throw new Error('Failed to refresh access token');
      }
    } catch (error) {
      console.error(error);
      throw error;
    }
  };

  async function login(UserReqDto) {
    try {
      const response = await postAuthLoginApi(UserReqDto);
      if (response.status === 200) {
        console.log('로그인 성공');
        const token = response.headers['access'];
        if (token) {
          setToken(token);
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

          apiClient.interceptors.response.use(
            (response) => {
              console.log('액세스 토큰 정상');
              return response; // 정상 반환이면 진행
            },
            async (error) => {
              // 401에러가 나온다면 쿠키를 이용해서 리프레쉬 토큰 발행
              const originalRequest = error.config;

              if (error.response.status === 401) {
                console.log('토큰 완전 만료');
                const newToken = await refreshAccessToken();
                setToken(newToken);
                originalRequest.headers['access'] = newToken;
                return apiClient(originalRequest);
              }
              return Promise.reject(error);
            }
          );
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
  }

  const value = {
    isAuthenticated,
    login,
    logout,
    username,
    token,
  };

  return (
    <AuthContext.Provider value={value}>{children}</AuthContext.Provider>
  );
}
