import { apiClient } from './ApiClient';

export const postAuthLoginApi = (UserReqDto) => {
  return apiClient.post('/login', UserReqDto);
};

export const postAuthLogoutApi = () => {
  return apiClient.post('/logout');
};

export const postSignupApi = (UserReqDto) => {
  return apiClient.post('/signup', UserReqDto);
};

// 서버로 새로운 액세스 토큰을 요청하는 API
export const postRefreshTokenApi = () => {
  return apiClient.post('/reissue', {}, {
    withCredentials: true // 리프레시 토큰이 HttpOnly 쿠키에 있으므로 반드시 필요
  });
};

export const getUserProfileApi = (nickname) => {
  return apiClient.get(`/api/v1/users/profile/${nickname}`);
};

export const updateUserProfileApi = (nickname, userProfileRequest) => {
  return apiClient.put(`/api/v1/users/profile/${nickname}`, userProfileRequest);
};

export const uploadProfileImageApi = (nickname, formData) => {
  return apiClient.put(`/api/v1/users/profile/${nickname}/image`, formData, {
    headers: {
      'Content-Type': 'multipart/form-data',
    },
  });
};
