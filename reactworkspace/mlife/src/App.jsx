import {createBrowserRouter, RouterProvider} from 'react-router-dom'
import HomePage from './pages/Home'
import LoginPage from './pages/Login'
import SignupPage from './pages/Signup'
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
