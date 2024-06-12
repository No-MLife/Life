import {apiClient} from '../api/ApiClient'


export const postPostLikeApi = async (postId) => {
    const response = await apiClient.post(`/api/v1/post/${postId}/like`);
    return response.data;
  };

  export const deletePostLikeApi = async (postId) => {
    const response = await apiClient.delete(`/api/v1/post/${postId}/like`);
    return response.data;
  };


  export const getPostLikeApi = async (postId) => {
    const response = await apiClient.get(`/api/v1/post/${postId}/like/liked`);
    return response.data;
  };