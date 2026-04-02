<template>
    <div style="padding: 50px; text-align: center;">
        <h1>Страница входа</h1>
        <button @click="fakeLogin">Войти (тест)</button>
    </div>
</template>

<script setup lang="ts">
import { useAuthStore } from '@/stores/useAuthStore';
import { useRouter } from 'vue-router';

const authStore = useAuthStore();
const router = useRouter();

const fakeLogin = () => {
    authStore.setToken('fake-jwt-tokeb-123');
    router.push('/');
};
</script>