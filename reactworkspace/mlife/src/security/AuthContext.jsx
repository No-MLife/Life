import { createContext, useContext, useState } from "react";
import { AuthLoginApi } from "../api/Auth";
import { apiClient } from "../api/ApiClient";

// 기본 AuthContext 값
const defaultValue = {
  isAuthenticated: false,
  login: async () => false,
  logout: () => {},
  username: null,
  token: null,
};

export const AuthContext = createContext(defaultValue);
export const useAuth = () => useContext(AuthContext);

export default function AuthProvider({ children }) {
  const [isAuthenticated, setAuthenticated] = useState(false);
  const [username, setUsername] = useState(null);
  const [token, setToken] = useState(null);

  /**
   * 사용자를 로그인하는 함수
   * @param {Object} userAccount 로그인 요청 객체
   * @returns {Promise<boolean>} 로그인 성공 여부
   */
  async function login(userAccount) {
    try {
      const response = await AuthLoginApi(userAccount);
      if (response.status === 200) {
        const token = response.headers['access'];
        setUsername(userAccount.username);
        setAuthenticated(true);
        setToken(token);

        if (token) {
          // 토큰이 있다면 인터셉트
          apiClient.interceptors.request.use((config) => {
            console.log('intercepting and adding a token');
            config.headers.Authorization = token;
            return config;
          });

          window.alert("로그인 되었습니다.");
          return true;
        } else {
          window.alert("토큰이 없습니다.");
          logout();
          return false;
        }
      } else {
        logout();
        return false; // 로그인 실패 처리
      }
    } catch (error) {
      console.log("로그인 실패", error);
      logout();
      return false; // 예외 발생 시 로그인 실패
    }
  }

  /**
   * 사용자를 로그아웃하는 함수
   */
  function logout() {
    setAuthenticated(false);
    setToken(null);
    setUsername(null);
  }

  // 상태 및 함수를 포함하는 value 객체
  const value = {
    isAuthenticated,
    login,
    logout,
    username,
    token,
  };

  return (
    <AuthContext.Provider value={value}>
      {children}
    </AuthContext.Provider>
  );
  
}
