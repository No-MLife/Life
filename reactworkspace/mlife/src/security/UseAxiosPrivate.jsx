import { apiClient } from "../api/ApiClient";
import { useEffect } from "react";
import { useAuth } from "./AuthContext";
import { postRefreshTokenApi } from '../api/UserApi';

const useAxiosPrivate = () => {
    const { token, setToken } = useAuth();

    const refreshAccessToken = async () => {
        try {
            const response = await postRefreshTokenApi();
            if (response.status === 200) {
                const newAccessToken = response.headers['access'];
                apiClient.defaults.headers.common['access'] = newAccessToken;
                return newAccessToken;
            } else {
                throw new Error('Failed to refresh access token');
            }
        } catch (error) {
            console.error(error);
            throw error;
        }
    };

    useEffect(() => {
        const requestIntercept = apiClient.interceptors.request.use(
            config => {
                if (!config.headers['access']) {
                    config.headers['access'] = token;
                }
                return config;
            },
            error => Promise.reject(error)
        );

        const responseIntercept = apiClient.interceptors.response.use(
            response => response,
            async (error) => {
                const prevRequest = error?.config;
                if (error?.response?.status === 401 && !prevRequest?.sent) {
                    prevRequest.sent = true;
                    try {
                        const newAccessToken = await refreshAccessToken();
                        setToken(newAccessToken);
                        prevRequest.headers['access'] = newAccessToken;
                        return apiClient(prevRequest);
                    } catch (err) {
                        return Promise.reject(err);
                    }
                }
                return Promise.reject(error);
            }
        );

        return () => {
            apiClient.interceptors.request.eject(requestIntercept);
            apiClient.interceptors.response.eject(responseIntercept);
        };
    }, [token]);

    return apiClient;
};

export default useAxiosPrivate;
