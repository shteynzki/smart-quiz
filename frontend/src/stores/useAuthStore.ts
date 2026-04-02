import { defineStore } from "pinia";
import { ref, computed } from 'vue';

export const useAuthStore = defineStore('auth', () => {
    const token = ref<string | null>(localStorage.getItem('token') || null);

    const user = ref<any | null>(null);

    const isAuthenticated = computed(() => !!token.value);

    const setToken = (newToken: string) => {
        token.value = newToken;
        localStorage.setItem('token', newToken);
    };

    const logout = () => {
        token.value = null;
        user.value = null;
        localStorage.removeItem('token');
    };

    return {
        token, user, isAuthenticated, setToken, logout
    };
});