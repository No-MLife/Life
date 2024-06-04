import { createContext, useContext, useState } from "react"
import { AuthLoginApi } from "../api/UserApi"
import {apiClient} from '../api/ApiClient'
import Cookies from 'js-cookie';

//1: 문맥 생성
export const AuthContext = createContext()
export const useAuth = () => useContext(AuthContext)

//2: 다른 컴포넌트와 공유할 문맥 셋팅
export default function AuthProvider({ children }) {

    //3: Put some state in the context
    const [isAuthenticated, setAuthenticated] = useState(false)
    const [username, setUsername] = useState(null)
    const [token, setToken] = useState(null)
    const [refreshToken, setRefreshToken] = useState(null)

   async function login(UserReqDto){
    try{
        const response = await AuthLoginApi(UserReqDto)
            if (response.status ===200){
                console.log("로그인 성공")
                const token = response.headers['access'];
                console.log(response.headers)
                const refresh = Cookies.get("refresh")

                console.log(refresh)



                if (token && refresh) {
                    setToken(token)
                    setRefreshToken(refreshToken)
                    setAuthenticated(true)
                    setUsername(UserReqDto.username)
                    apiClient.interceptors.request.use((config) => {
                      console.log('intercepting and adding a token')
                      config.headers.Authorization = token
                      return config
                    })
                    return true
                  }
            }
            else{
                logout()
                return false
            }
    }
    catch(error){
        logout()
        return false
    }
    
   };

    function logout() {
        setAuthenticated(false)
        setToken(null)
        setUsername(null)
    };
    const value = {
        isAuthenticated,
        login,
        logout,
        username,
        token
    };

    return (
        // value
        <AuthContext.Provider value={ value }>
            {children}
        </AuthContext.Provider>
    )
} 