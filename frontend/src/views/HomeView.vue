<template>
  <div>
    <h1>Мои проекты</h1>
    
    <div v-if="isLoading">Загрузка данных с сервера...</div>

    <ul v-else>
      <li v-for="project in projects" :key="project.id">
        {{ project.title }} — {{ project.status }}
      </li>
    </ul>

    <button @click="handleLogout">Выйти</button>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { fetchProjects, type Project } from '@/api/projects';
import { useAuthStore } from '@/stores/useAuthStore';
import { useRouter } from 'vue-router';

const projects = ref<Project[]>([]);
const isLoading = ref(false);
const authStore = useAuthStore();
const router = useRouter();

const handleLogout = () => {
    authStore.logout();
    router.push({ name: 'Login' })
}

onMounted(async () => {
  try {
    isLoading.value = true;
    // Вызываем функцию. Если в .env стоит VITE_USE_MOCKS=true, 
    // она подождет 800мс и отдаст захардкоженный массив.
    projects.value = await fetchProjects(); 
  } catch (error) {
    console.error("Ошибка при загрузке проектов", error);
  } finally {
    isLoading.value = false;
  }
});
</script>