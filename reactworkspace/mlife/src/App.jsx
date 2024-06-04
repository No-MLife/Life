import {createBrowserRouter, RouterProvider} from 'react-router-dom'
import HomePage from './pages/post/Home'
import LoginPage from './pages/user/Login'
import SignupPage from './pages/user/Signup'
import './App.css'
import AuthProvider, {useAuth} from "./security/AuthContext"

function AuthenticateRoute({children}){
  const authContext = useAuth(); // useAuth를 통해 유저 정보를 공통적으로 접근 가능하다.
  console.log(authContext)

  if (authContext.isAuthenticated){
      return children;
  }
  alert("로그인 후 이용해주세요")
  return <Navigate to="/"/>
}

const router = createBrowserRouter([
  { path :'/', element : <HomePage/> },
  { path :'/login', element : <LoginPage/> },
  { path :'/signup', element : <SignupPage/> },

]);

function App() {
return (
  // AuthProvider는 공통적으로 관리할 context에 대한 정보들이다. (유저의 닉네임, 로그인 여부 등등...)
    <AuthProvider> 
      <RouterProvider router={router}/>
    </AuthProvider>
)
}

export default App
