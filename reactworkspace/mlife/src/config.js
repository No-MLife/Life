// src/config.js
const backendUrl = process.env.REACT_APP_BACKEND_URL || 'http://3.36.235.167:8080';
// const backendUrl = 'http://localhost:8080';
console.log('Backend URL:', backendUrl);  // 디버그 문 추가
export default backendUrl;
