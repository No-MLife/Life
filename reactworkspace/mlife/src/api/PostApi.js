import {apiClient} from './ApiClient'

export const getPopulaPostsApi = async () => {
    const response = await apiClient.get(`/api/v1/category/popular-posts/100`);
    return response.data;
  };