<script setup lang="ts">
import { computed } from "vue";
import { useRouter } from "vue-router";
import { useAuthStore } from "@/stores/useAuthStore";

const router = useRouter();
const authStore = useAuthStore();

const primaryActionLabel = computed(() =>
  authStore.isAuthenticated ? "На главную" : "Войти"
);

const handlePrimaryAction = () => {
  router.push(authStore.isAuthenticated ? { name: "Home" } : { name: "Login" });
};
</script>

<template>
  <section class="not-found">
    <div class="not-found__card">
      <p class="not-found__code">404</p>
      <h1 class="not-found__title">Страница не найдена</h1>
      <p class="not-found__text">
        Возможно, ссылка устарела или адрес был введен с ошибкой.
      </p>

      <div class="not-found__actions">
        <button class="not-found__button not-found__button--primary" type="button" @click="handlePrimaryAction">
          {{ primaryActionLabel }}
        </button>
        <button class="not-found__button not-found__button--ghost" type="button" @click="router.back()">
          Назад
        </button>
      </div>
    </div>
  </section>
</template>

<style scoped>
.not-found {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 24px;
  background:
    radial-gradient(circle at top, rgba(var(--primary-rgb), 0.12), transparent 40%),
    linear-gradient(180deg, #f8fbff 0%, #eef3f8 100%);
}

.not-found__card {
  width: min(100%, 560px);
  padding: 48px 32px;
  border: 1px solid rgba(var(--primary-rgb), 0.12);
  border-radius: 28px;
  background: rgba(255, 255, 255, 0.92);
  box-shadow: 0 24px 60px rgba(0, 33, 71, 0.12);
  text-align: center;
}

.not-found__code {
  margin: 0 0 12px;
  font-size: clamp(4rem, 15vw, 7rem);
  line-height: 0.9;
  font-weight: 800;
  color: var(--primary);
}

.not-found__title {
  margin: 0 0 12px;
  font-size: clamp(1.8rem, 4vw, 2.6rem);
}

.not-found__text {
  margin: 0 auto;
  max-width: 420px;
  font-size: 1rem;
  line-height: 1.6;
  color: var(--text);
}

.not-found__actions {
  display: flex;
  justify-content: center;
  gap: 12px;
  margin-top: 28px;
  flex-wrap: wrap;
}

.not-found__button {
  min-width: 150px;
  padding: 14px 20px;
  font-size: 1rem;
  font-weight: 600;
}

.not-found__button--primary {
  color: var(--white);
  background: var(--primary);
}

.not-found__button--primary:hover {
  background: var(--primary-hover);
}

.not-found__button--ghost {
  color: var(--primary);
  background: transparent;
  border: 1px solid rgba(var(--primary-rgb), 0.24);
}

.not-found__button--ghost:hover {
  background: rgba(var(--primary-rgb), 0.06);
}

@media (max-width: 640px) {
  .not-found__card {
    padding: 40px 20px;
    border-radius: 22px;
  }

  .not-found__actions {
    flex-direction: column;
  }

  .not-found__button {
    width: 100%;
  }
}
</style>