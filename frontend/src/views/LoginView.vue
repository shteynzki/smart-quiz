<template>
  <div class="login-page">
    <!-- 1. Фоновые "живые" пятна для глубины -->
    <div class="bg-blobs">
      <div class="blob blob-1"></div>
      <div class="blob blob-2"></div>
    </div>

    <div class="login-card">
      <div class="brand-icon-wrapper">
        <!-- Парящая иконка -->
        <IconBox class="floating-icon" />
      </div>

      <h1 class="login-title">ДИЗАЙН-ПРОЕКТ ПОМЕЩЕНИЯ</h1>
      <p class="login-description">
        Начните проектирование вашего идеального интерьера прямо сейчас — это
        быстро и бесплатно.
      </p>

      <div class="actions">
        <!-- Твоя кнопка с эффектом мерцания -->
        <button
          @click="fakeLogin"
          class="btn-nav btn-next login-btn-wide shimmer-btn"
        >
          Войти в систему
        </button>
      </div>

      <!-- 2. Блок преимуществ для вовлечения -->
      <div class="features-grid">
        <div class="feature-item">
          <span class="feature-icon">⚡</span>
          <p>2 минуты</p>
        </div>
        <div class="feature-item">
          <span class="feature-icon">💎</span>
          <p>Бесплатно</p>
        </div>
        <div class="feature-item">
          <span class="feature-icon">🏠</span>
          <p>Точный расчет</p>
        </div>
      </div>

      <div class="status-bar">
        <span class="status-dot"></span>
        <span class="status-text">Система готова</span>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { useAuthStore } from "@/stores/useAuthStore";
import { useRouter } from "vue-router";

const authStore = useAuthStore();
const router = useRouter();

const fakeLogin = () => {
  authStore.setToken("guest-access-token");
  router.push("/");
};
</script>

<style scoped>
/* --- БАЗОВЫЕ СТИЛИ И ФОН --- */
.login-page {
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 100vh;
  background: var(--bg);
  padding: 20px;
  overflow: hidden;
}

.bg-blobs {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: 0;
}

.blob {
  position: absolute;
  width: 500px;
  height: 500px;
  background: var(--primary);
  filter: blur(100px);
  opacity: 0.07;
  border-radius: 50%;
  animation: moveBlobs 20s infinite alternate;
}

.blob-1 {
  top: -10%;
  left: -10%;
}
.blob-2 {
  bottom: -10%;
  right: -10%;
  animation-delay: -5s;
}

/* --- КАРТОЧКА --- */
.login-card {
  position: relative;
  z-index: 1;
  background: var(--white);
  padding: 45px;
  border-radius: 16px;
  box-shadow: 0 20px 50px rgba(0, 0, 0, 0.05);
  border: 1px solid var(--border);
  max-width: 460px;
  width: 100%;
  text-align: center;
  animation: fadeInDown 0.8s cubic-bezier(0.22, 1, 0.36, 1);
}

.brand-icon-wrapper {
  margin-bottom: 24px;
}

.floating-icon {
  font-size: 4rem;
  color: var(--primary);
  display: inline-block;
  animation: float 3.5s ease-in-out infinite;
}

.login-title {
  font-size: 1.6rem;
  color: var(--primary);
  margin-bottom: 12px;
  font-weight: 800;
  letter-spacing: 0.5px;
}

.login-description {
  color: #718096;
  line-height: 1.6;
  margin-bottom: 35px;
  font-size: 1.05rem;
}

/* --- КНОПКА С ТВОИМИ СТИЛЯМИ И БЛИКОМ --- */
.login-btn-wide {
  width: 100%;
  font-size: 1.15rem;
  padding: 18px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
  transition:
    transform 0.2s,
    filter 0.2s;
}

.shimmer-btn::after {
  content: "";
  position: absolute;
  top: -50%;
  left: -150%;
  width: 50%;
  height: 200%;
  background: linear-gradient(
    to right,
    rgba(255, 255, 255, 0) 0%,
    rgba(255, 255, 255, 0.3) 50%,
    rgba(255, 255, 255, 0) 100%
  );
  transform: rotate(25deg);
  animation: shimmer 4s infinite;
}

.login-btn-wide:active {
  transform: scale(0.97);
}

/* --- БЛОК ПРЕИМУЩЕСТВ --- */
.features-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 15px;
  margin-top: 35px;
  padding-top: 30px;
  border-top: 1px solid #edf2f7;
}

.feature-item {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.feature-icon {
  font-size: 1.3rem;
  margin-bottom: 6px;
}

.feature-item p {
  font-size: 0.75rem;
  font-weight: 600;
  color: #a0aec0;
  margin: 0;
  text-transform: uppercase;
}

.status-bar {
  margin-top: 25px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  opacity: 0.7;
}

.status-dot {
  width: 7px;
  height: 7px;
  background: #48bb78;
  border-radius: 50%;
  box-shadow: 0 0 6px #48bb78;
}

.status-text {
  font-size: 0.8rem;
  color: #a0aec0;
}

/* --- АНИМАЦИИ --- */
@keyframes fadeInDown {
  from {
    opacity: 0;
    transform: translateY(-30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes float {
  0%,
  100% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-12px);
  }
}

@keyframes moveBlobs {
  from {
    transform: translate(0, 0) scale(1);
  }
  to {
    transform: translate(40px, 60px) scale(1.1);
  }
}

@keyframes shimmer {
  0% {
    left: -150%;
  }
  30%,
  100% {
    left: 250%;
  }
}

/* --- АДАПТИВНОСТЬ --- */
@media (min-width: 1024px) {
  .login-card {
    padding: 60px;
    max-width: 500px;
  }
}

@media (max-width: 768px) {
  .login-card {
    padding: 40px 30px;
    max-width: 420px;
  }
  .login-title {
    font-size: 1.5rem;
  }
}

@media (max-width: 375px) {
  .login-card {
    padding: 30px 20px;
    width: 95%;
  }
  .login-title {
    font-size: 1.3rem;
  }
  .login-description {
    font-size: 0.95rem;
  }
  .features-grid {
    gap: 10px;
  }
}

@media (max-width: 320px) {
  .login-card {
    padding: 25px 15px;
  }
  .login-title {
    font-size: 1.15rem;
  }
  .floating-icon {
    font-size: 3rem;
  }
  .login-btn-wide {
    padding: 14px;
    font-size: 1rem;
  }
  .feature-icon {
    font-size: 1.1rem;
  }
}
</style>
