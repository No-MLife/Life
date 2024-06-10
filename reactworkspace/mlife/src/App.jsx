import { BrowserRouter, Route, Routes } from 'react-router-dom';
import HomePage from './pages/post/HomePage';
import LoginPage from './pages/user/Login';
import SignupPage from './pages/user/Signup';
import './App.css';
import AuthProvider from "./security/AuthContext";
import CategoryPage from './pages/post/CategoryPage';
import PostDetailPage from './pages/post/PostDetailPage';
import PostWrtiePage from './pages/post/PostWritePage'
import PostEditPage from './pages/post/PostEditPage'
import UserProfilePage from './pages/user/UserProfile'
// import ProfilePage from './pages/user/Profile';
// import AuthenticateRoute from './AuthenticateRoute';
import Layout from './components/Layout';  // 새로 만든 Layout 컴포넌트

function App() {
  return (
    <AuthProvider>
      <BrowserRouter>
        <Routes>
          <Route element={<Layout />}>
            <Route path="/" element={<HomePage />} />
            <Route path="/:categoryId" element={<CategoryPage />} />
            <Route path="/post/:postId" element={<PostDetailPage />} />
            <Route path="/write" element={< PostWrtiePage/>} />
            <Route path="/post/:postId/edit" element={< PostEditPage/>} />
            <Route path="/user/profile" element={< UserProfilePage/>} />
            {/* <Route path="/profile" element={<AuthenticateRoute><ProfilePage /></AuthenticateRoute>} /> */}
          </Route>
          <Route path="/login" element={<LoginPage />} />
          <Route path="/signup" element={<SignupPage />} />
        </Routes>
      </BrowserRouter>
    </AuthProvider>
  );
}

export default App;
