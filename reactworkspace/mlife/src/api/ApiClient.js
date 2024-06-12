import axios from 'axios'
import { postRefreshTokenApi } from '../api/UserApi';
const BASE_URL = 'http://localhost:8080'
export const apiClient = axios.create(
    {
        baseURL: BASE_URL,
        headers: {
            "Content-Type": "application/json",
          },
          withCredentials: true,
    }
)

export const setAuthToken = (token) => {
  if (token) {
    apiClient.defaults.headers.common['access'] = token;
  } else {
    delete apiClient.defaults.headers.common['access'];
  }
};

export const setupInterceptors = (token, setToken, logout) => {
  apiClient.interceptors.request.use(
    config => {
      if (!config.headers['access']) {
        config.headers['access'] = token;
      }
      return config;
    },
    error => Promise.reject(error)
  );

  apiClient.interceptors.response.use(
    response => response,
    async (error) => {
      const prevRequest = error?.config;
      if (error?.response?.status === 401 && !prevRequest?.sent) {
        prevRequest.sent = true;
        try {
          const response = await postRefreshTokenApi();
          if (response.status === 200) {
            const newAccessToken = response.headers['access'];
            setToken(newAccessToken);
            apiClient.defaults.headers.common['access'] = newAccessToken;
            prevRequest.headers['access'] = newAccessToken;
            return apiClient(prevRequest);
          } else {
            logout();
            throw new Error('Failed to refresh access token');
          }
        } catch (err) {
          logout();
          return Promise.reject(err);
        }
      }
      return Promise.reject(error);
    }
  );
};
