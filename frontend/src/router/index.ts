import { createRouter, createWebHistory } from "vue-router";
import { useAuthStore } from "@/stores/useAuthStore";


const router = createRouter({
    history: createWebHistory(import.meta.env.VITE_API_BASE_URL),
    routes: [
        {
            path: '/',
            name: 'Home',
            component: () => import('@/views/HomeView.vue'),
            meta: { requiresAuth: true }
        },
        {
            path: '/login',
            name: 'Login',
            component: () => import('@/views/LoginView.vue'),
            meta: { requiresAuth: false }
        }
    ]
});

router.beforeEach((to, from, next) => {
    const authStore = useAuthStore();

    if (to.meta.requiresAuth && !authStore.isAuthenticated) {
        next({ name: 'Home' });
    } else {
        next();
    }
});

export default router;