<template>
  <div class="quiz-container">
    <!-- Прогресс-бар -->
    <div class="quiz-header">
      <div class="progress-info">Шаг {{ store.currentStep }} из 6</div>
      <div class="progress-bar">
        <div
          class="progress-fill"
          :style="{ width: (store.currentStep / 6) * 100 + '%' }"
        ></div>
      </div>
    </div>

    <div class="quiz-content">
      <!-- ШАГ 1: Тип помещения -->
      <div v-if="store.currentStep === 1">
        <h2>Какое помещение вы планируете оформить?</h2>
        <div class="options-grid">
          <button
            v-for="opt in [
              'Квартира',
              'Частный дом',
              'Офис',
              'Коммерция',
              'Студия',
              'Другое',
            ]"
            :key="opt"
            @click="selectStep1(opt)"
            class="btn-option"
          >
            {{ opt }}
          </button>
        </div>
      </div>

      <!-- ШАГ 2: Зоны (Множественный выбор) -->
      <div v-if="store.currentStep === 2">
        <h2>Какие зоны нужно включить в проект?</h2>
        <div class="checkbox-group">
          <label
            v-for="zone in [
              'Кухня',
              'Гостиная',
              'Спальня',
              'Детская',
              'Санузел',
              'Прихожая',
              'Балкон',
              'Полностью всё',
            ]"
            :key="zone"
            class="checkbox-item"
          >
            <input
              type="checkbox"
              :value="zone"
              v-model="store.answers.step_2"
            />
            <span>{{ zone }}</span>
          </label>
        </div>
      </div>

      <!-- ШАГ 3: Площадь (Слайдер) -->
      <div v-if="store.currentStep === 3">
        <h2>
          Укажите примерную площадь:
          <strong>{{ store.answers.step_3 }} м²</strong>
        </h2>
        <input
          type="range"
          min="20"
          max="300"
          step="5"
          v-model.number="store.answers.step_3"
          class="slider"
        />
      </div>

      <!-- ШАГ 4: Стиль -->
      <div v-if="store.currentStep === 4">
        <h2>Какой стиль интерьера вам ближе?</h2>
        <div class="options-grid">
          <button
            v-for="s in [
              'Современный',
              'Минимализм',
              'Скандинавский',
              'Лофт',
              'Классика',
              'Не определился',
            ]"
            :key="s"
            @click="selectStep4(s)"
            class="btn-option"
          >
            {{ s }}
          </button>
        </div>
      </div>

      <!-- ШАГ 5: Бюджет -->
      <div v-if="store.currentStep === 5">
        <h2>Какой бюджет вы рассматриваете?</h2>
        <div class="options-grid">
          <button
            v-for="b in [
              'До 500к ₽',
              '500к – 1млн ₽',
              '1млн – 2млн ₽',
              'От 2млн ₽',
              'Не знаю',
            ]"
            :key="b"
            @click="selectStep5(b)"
            class="btn-option"
          >
            {{ b }}
          </button>
        </div>
      </div>

      <!-- ШАГ 6: Контакты -->
      <div v-if="store.currentStep === 6">
        <h2>Оставьте контакты для связи</h2>
        <div class="form-group">
          <input
            v-model="store.contact.name"
            placeholder="Ваше имя"
            class="input-field"
          />
          <input
            v-model="store.contact.phone"
            placeholder="Телефон (обязательно)"
            class="input-field"
          />
          <textarea
            v-model="store.contact.comment"
            placeholder="Комментарий (необязательно)"
            class="input-field"
          ></textarea>
          <label class="checkbox-item">
            <input type="checkbox" v-model="agreed" />
            <span>Согласен на обработку данных</span>
          </label>
        </div>
        <button
          :disabled="!isFormValid || loading"
          @click="handleFinalSubmit"
          class="btn-submit"
        >
          {{ loading ? "Отправка..." : "Получить консультацию" }}
        </button>
      </div>

      <!-- ЭКРАН УСПЕХА -->
      <div v-if="store.currentStep === 7" class="success-screen">
        <h2>Спасибо! 🎉</h2>
        <p>Ваша заявка принята. Мы свяжемся с вами в ближайшее время.</p>
        <button @click="resetQuiz" class="btn-option">
          Вернуться в начало
        </button>
      </div>
    </div>

    <!-- Кнопки навигации -->
    <div class="quiz-footer" v-if="store.currentStep < 7">
      <button
        v-if="store.currentStep > 1"
        @click="store.prevStep"
        class="btn-nav"
      >
        Назад
      </button>
      <button
        v-if="isNextVisible"
        @click="store.nextStep"
        class="btn-nav btn-next"
      >
        Далее
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from "vue";
import { useQuizStore } from "@/stores/useQuizStore";
import { submitQuiz } from "@/api/projects";
import { useAuthStore } from '@/stores/useAuthStore';
import { useRouter } from 'vue-router';
import "@/assets/quiz.css";

const store = useQuizStore();
const loading = ref(false);
const agreed = ref(false);
const authStore = useAuthStore();
const router = useRouter();

// Логика автоматического перехода для одиночных выборов
const selectStep1 = (val: string) => {
  store.answers.step_1 = val;
  store.nextStep();
};
const selectStep4 = (val: string) => {
  store.answers.step_4 = val;
  store.nextStep();
};
const selectStep5 = (val: string) => {
  store.answers.step_5 = val;
  store.nextStep();
};

const isNextVisible = computed(() => {
  if (store.currentStep === 2) return store.answers.step_2.length > 0;
  if (store.currentStep === 3) return true;
  return false;
});

const isFormValid = computed(() => {
  return store.contact.phone.trim().length > 5 && agreed.value;
});

const handleFinalSubmit = async () => {
  loading.value = true;
  const payload = {
    lead: {
      ...store.contact,
      answers: store.answers,
    page_url: window.location.href,
    },
  };
  try {
    await submitQuiz(payload);
    store.currentStep = 7;
  } catch (e) {
    alert("Ошибка при отправке");
  } finally {
    loading.value = false;
  }
};

const resetQuiz = () => {
    authStore.logout();
    router.push({ name: 'Login' })
};
</script>
