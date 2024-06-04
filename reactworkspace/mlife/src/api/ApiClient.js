import axios from 'axios'
export const apiClient = axios.create(
    {
        withCredentials: true,
        baseURL: 'http://localhost:8080',
        headers: {
            "Content-Type": "application/json",
          },
    }
)
