import { createRouter, createWebHistory } from "vue-router";
import { useAuthStore } from "@/stores/useAuthStore";


const router = createRouter({
    history: createWebHistory(),
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

router.beforeEach((to, _from, next) => {
    const authStore = useAuthStore();

    if (to.meta.requiresAuth && !authStore.isAuthenticated) {
        next({ name: 'Login' });
    } else if (to.name === 'Login' && authStore.isAuthenticated) {
        next({ name: 'Home' });
    } else {
        next();
    }
});

export default router;