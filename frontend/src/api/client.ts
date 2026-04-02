import axios from "axios";
import { useAuthStore } from "@/stores/useAuthStore";
import router from "@/router";

export const apiClient = axios.create({
    baseURL: import.meta.env.VITE_API_BASE_URL,
    timeout: 10000,
    headers: { "Content-Type": "application/json", }
});

apiClient.interceptors.request.use(
    (config) => {
        const authStore = useAuthStore();

        if (authStore.token && config.headers) {
            config.headers.Authorization = `Bearer ${authStore.token}`;
        }
        return config;
    },
    (error) => {
        return Promise.reject(error);
    }
);

apiClient.interceptors.response.use(
    (response) => {
        return response;
    },
    (error) => {
        const authStore = useAuthStore();

        if (error.response && error.response.status == 401) {
            authStore.logout();
            router.push({name: 'Login'})
        }

        return Promise.reject(error);
    }
)