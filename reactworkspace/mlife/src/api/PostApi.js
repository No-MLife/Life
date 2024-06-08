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

export const deletePostApi = async (postid) => {
  return await apiClient.delete(`/api/v1/category/post/${postid}`);
  };


export const putPostApi = async (postid, post) => {
  return await apiClient.put(`/api/v1/category/post/${postid}`, post);
  };