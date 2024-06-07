import {apiClient} from './ApiClient'

export const getPopulaPostsApi = async () => {
    const response = await apiClient.get(`/api/v1/category/popular-posts/100`);
    return response.data;
  };

export const getPostsByCategoryApi = async (categoryId) => {
    const response = await apiClient.get(`/api/v1/category/${categoryId}`);
    return response.data;
  };

export const getPostByIdApi = async (postid) => {
  const response = await apiClient.get(`/api/v1/category/post/${postid}`);
  return response.data;
  };

