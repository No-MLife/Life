import {apiClient} from './ApiClient'

export const postAuthLoginApi = 
(UserReqDto) => apiClient.post("/login", UserReqDto)

export  const postSignupApi = 
(UserReqDto) => apiClient.post("/signup", UserReqDto)

// export const AuthSignupApi = 
// (userAccount: { userId: string; userPassword: string; email: string; nickname: string; memo: string; }) =>
//     apiClinet.post("/api/sign-up", userAccount)