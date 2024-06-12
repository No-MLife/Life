// import {apiClient} from './ApiClient'
import UseAxiosPrivate from '../security/UseAxiosPrivate'

const apiClient = UseAxiosPrivate();

export const postCommentApi = async (postid, comment) => {
    return await apiClient.post(`/api/v1/post/${postid}/comment`, comment);
  };

export const putCommentApi = async (postid, commentid, comment) => {
    return await apiClient.put(`/api/v1/post/${postid}/comment/${commentid}`, comment);
  };

export const deleteCommentApi = async (postid, commentid) => {
    return await apiClient.delete(`/api/v1/post/${postid}/comment/${commentid}`);
  };

export const getCommentsApi = async (postid) => {
    return await apiClient.get(`/api/v1/post/${postid}/comment`);
  };

// export const getPostByIdApi = async (postid) => {
//   const response = await apiClient.get(`/api/v1/category/post/${postid}`);
//   return response.data;
//   };

