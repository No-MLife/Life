import {createBrowserRouter, RouterProvider} from 'react-router-dom'
import HomePage from './pages/post/Home'
import LoginPage from './pages/user/Login'
import SignupPage from './pages/user/Signup'
import './App.css'

const router = createBrowserRouter([
  { path :'/', element : <HomePage/> },
  { path :'/login', element : <LoginPage/> },
  { path :'/signup', element : <SignupPage/> },

]);

function App() {
return <RouterProvider router={router}/>
}

export default App
