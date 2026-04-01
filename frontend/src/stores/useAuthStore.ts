import { defineStore } from "pinia";
import { ref, computed } from 'vue';
import { useRouter } from 'vue-router';

export const useAuthStore = defineStore('auth', () => {
    const token = ref<string | null>(localStorage.getItem('token') || null);
    const router = useRouter();

    const isAuthenticated = computed(() => !!token.value);

    const setToken = (newToken: string) => {
        token.value = newToken;
        localStorage.setItem('token', newToken);
    };

    const logout = () => {
        token.value= null;
        localStorage.removeItem('token');
        router.push('/login');
    };

    return {
        token, isAuthenticated, setToken, logout
    };
});