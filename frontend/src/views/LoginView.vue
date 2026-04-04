<template>
  <div class="login-page">
    <div class="login-card-refined">
      <div class="card-image-layer"></div>

      <div class="card-overlay-light"></div>

      <div class="card-content">
        <h1 class="login-title">Дизайн-проект вашего интерьера</h1>

        <div class="description-container">
          <p class="login-subtitle">Узнайте стоимость и сроки за 2 минуты</p>

          <p class="login-subtitle">
            Ответьте на 6 вопросов, чтобы получить расчет бюджета и персональную
            консультацию.
          </p>
        </div>

        <button @click="fakeLogin" class="start-button-refined">
          Рассчитать проект
        </button>
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
@import url("https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;800&display=swap");

.login-page {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 100vh;
  background-color: #ffffff;
  padding: 20px;
  font-family: "Montserrat", sans-serif;
}

.login-card-refined {
  position: relative;
  max-width: 480px;
  width: 100%;
  border-radius: 24px;
  overflow: hidden;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
  text-align: center;
  min-height: 520px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  border: 1px solid #f0f0f0;
}

.card-image-layer {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-image: url("@/assets/login.png");
  background-size: cover;
  background-position: center;
  filter: blur(0);
  opacity: 2;
  z-index: 0;
}
.card-overlay-light {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: linear-gradient(
    to bottom,
    rgba(255, 255, 255, 0.9) 0%,
    rgba(255, 255, 255, 0.7) 20%,
    rgba(255, 255, 255, 0.7) 40%,
    rgba(255, 255, 255, 0.9) 80%
  );
  z-index: 1;
}

.card-content {
  position: relative;
  z-index: 2;
  padding: 50px 35px;
  color: #1a1a1a;
}

.login-title {
  font-size: 26px;
  color: #000000;
  font-weight: 800;
  margin-bottom: 25px;
  line-height: 1.2;
}

.description-container {
  margin-bottom: 40px;
}

.login-subtitle {
  font-size: 17px;
  font-weight: 600;
  color: #222222;
  margin-bottom: 15px;
}

.start-button-refined {
  background-color: #3b82f6;
  color: #ffffff;
  border: none;
  padding: 14px 40px;
  width: auto;
  display: inline-block;
  border-radius: 50px;
  font-size: 14px;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 1.2px;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
}

.start-button-refined:hover {
  background-color: #ffffff;
  color: #3b82f6;
  transform: translateY(-3px);
  box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);
}

@media (max-width: 1023px) {
  .login-card-refined {
    max-width: 440px;
    min-height: 480px;
  }

  .login-title {
    font-size: 24px;
  }
}

@media (max-width: 767px) {
  .login-page {
    padding: 15px;
  }

  .login-card-refined {
    max-width: 100%;
    border-radius: 20px;
    min-height: 450px;
  }

  .card-content {
    padding: 40px 25px;
  }

  .login-title {
    font-size: 22px;
    margin-bottom: 20px;
  }
}

@media (max-width: 375px) {
  .login-card-refined {
    min-height: 420px;
  }

  .login-title {
    font-size: 20px;
  }

  .login-subtitle {
    font-size: 15px;
  }

  .start-button-refined {
    padding: 12px 30px;
    font-size: 13px;
    width: 100%;
  }
}

@media (max-width: 320px) {
  .login-page {
    padding: 10px;
  }

  .card-content {
    padding: 30px 20px;
  }

  .login-title {
    font-size: 18px;
    margin-bottom: 15px;
  }

  .login-subtitle {
    font-size: 14px;
    margin-bottom: 10px;
  }

  .description-container {
    margin-bottom: 30px;
  }
}
</style>
