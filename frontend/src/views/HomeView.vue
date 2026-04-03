<template>
  <div class="quiz-container">
    <!-- Прогресс-бар -->
    <div class="quiz-header" v-if="store.currentStep <= 6">
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
            @click="handleStep1(opt)"
            :class="['btn-option', { active: store.answers.step_1 === opt }]"
          >
            {{ opt }}
          </button>
        </div>

        <div v-if="showStep1Other" class="other-input-wrapper">
          <input
            v-model="step1OtherValue"
            placeholder="Укажите свой вариант..."
            class="input-field"
            @keyup.enter="confirmStep1Other"
          />
          <button @click="confirmStep1Other" class="btn-nav btn-next">
            Подтвердить
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
              @change="handleZoneChange(zone)"
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
              'Неоклассика',
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
            placeholder="Телефон: +7 (900) 000-00-00"
            class="input-field"
            type="tel"
          />

          <input
            v-model="store.contact.email"
            placeholder="E-mail (необязательно)"
            class="input-field"
            type="email"
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
          :disabled="loading"
          @click="handleFinalSubmit"
          class="btn-submit"
        >
          {{ loading ? "Отправка..." : "Получить консультацию" }}
        </button>
        <p v-if="!isFormValid" class="validation-hint">
          * Заполните телефон и подтвердите согласие
        </p>
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

// Переменные для логики "Другое" на Шаге 1
const showStep1Other = ref(false);
const step1OtherValue = ref("");

const getUtms = () => {
  const urlParams = new URLSearchParams(window.location.search);
  return {
    utm_source: urlParams.get("utm_source") || "",
    utm_medium: urlParams.get("utm_medium") || "",
    utm_campaign: urlParams.get("utm_campaign") || "",
    utm_content: urlParams.get("utm_content") || "",
    utm_term: urlParams.get("utm_term") || "",
  };
};

const handleStep1 = (val: string) => {
  if (val === "Другое") {
    showStep1Other.value = true;
    store.answers.step_1 = "Другое";
  } else {
    showStep1Other.value = false;
    store.answers.step_1 = val;
    store.nextStep();
  }
};

const confirmStep1Other = () => {
  if (step1OtherValue.value.trim()) {
    store.answers.step_1 = step1OtherValue.value;
    store.nextStep();
  }
};

const handleZoneChange = (lastSelected: string) => {
  const ALL_KEY = "Полностью всё";
  if (lastSelected === ALL_KEY) {
    store.answers.step_2 = [ALL_KEY];
  } else {
    store.answers.step_2 = store.answers.step_2.filter((z) => z !== ALL_KEY);
  }
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
  if (store.currentStep === 1) return false;
  if (store.currentStep === 2) return store.answers.step_2.length > 0;
  if (store.currentStep === 3) return true;
  return false;
});

const isFormValid = computed(() => {
  const phoneDigits = store.contact.phone
    ? store.contact.phone.replace(/\D/g, "")
    : "";
  return phoneDigits.length === 11 && agreed.value;
});

const handleFinalSubmit = async () => {
  if (!isFormValid.value) {
    alert(
      "Пожалуйста, введите корректный номер (11 цифр) и примите соглашение.",
    );
    return;
  }

  loading.value = true;

  const utms = getUtms();

  const payload = {
    lead: {
      name: store.contact.name,
      phone: store.contact.phone,
      email: store.contact.email || "",
      comment: store.contact.comment || "",
      answers: store.answers,
      page_url: window.location.href,
      ...utms,
    },
  };

  try {
    const response = await submitQuiz(payload);
    console.log("Успех:", response);
    store.currentStep = 7;
  } catch (e) {
    console.error("Ошибка при отправке:", e);
    alert("Ошибка при отправке. Попробуйте еще раз.");
  } finally {
    loading.value = false;
  }
};

const resetQuiz = () => {
  window.location.reload();
  authStore.logout();
  router.push({ name: 'Login' })
};
</script>
