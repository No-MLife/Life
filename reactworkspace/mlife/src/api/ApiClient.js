import axios from 'axios'
export const apiClient = axios.create(
    {
        baseURL: 'http://172.30.1.59:8080',
        // baseURL: 'http://3.34.74.243:8080',
        
    }
)