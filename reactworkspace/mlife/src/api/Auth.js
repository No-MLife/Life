import {} from './ApiClient'

export const AuthLoginApi = () => apiclient.post("/login", UserReqDto)


// export const AuthSignupApi = 
// (userAccount: { userId: string; userPassword: string; email: string; nickname: string; memo: string; }) =>
//     apiClinet.post("/api/sign-up", userAccount)