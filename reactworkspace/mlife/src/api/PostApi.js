import {apiClient} from '../api/ApiClient'


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


  export const postPostApi = async (categoryId, formData) => {
    try {
      const response = await apiClient.post(`/api/v1/category/${categoryId}/post`, formData, {
        headers: {
          'Content-Type': 'multipart/form-data'
        }
      });
      return response;
    } catch (error) {
      console.error('Failed to create post:', error);
      throw error;
    }
  };

  export const putPostApi = async (categoryId, postid, formData) => {
    try {
      const response = await apiClient.put(`/api/v1/category/${categoryId}/post/${postid}`, formData, {
        headers: {
          'Content-Type': 'multipart/form-data'
        }
      });
      return response;
    } catch (error) {
      console.error('Failed to update post:', error);
      throw error;
    }
  };
  