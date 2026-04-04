<template>
  <div class="quiz-container">
    <div v-if="store.currentStep <= 6" class="progress-section">
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
      <div v-if="store.currentStep === 1" class="step-content">
        <h2>Какое помещение вы планируете оформить?</h2>
        <div class="options-grid card-grid">
          <label
            v-for="opt in [
              'Квартира',
              'Частный дом',
              'Офис',
              'Коммерческое помещение',
              'Студия / апартаменты',
              'Другое',
            ]"
            :key="opt"
            class="card-option"
            :class="{ active: store.answers.step_1 === opt }"
            @click="handleStep1(opt)"
          >
            <div class="card-icon-placeholder"><IconBox /></div>
            <span class="card-text">{{ opt }}</span>
          </label>
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

      <!-- ШАГ 2: Зоны -->
      <div v-if="store.currentStep === 2" class="step-content">
        <h2>Какие зоны нужно включить в проект?</h2>
        <div class="options-grid card-grid">
          <label
            v-for="zone in zonesList"
            :key="zone"
            class="card-option"
            :class="{
              active: store.answers.step_2.includes(zone),
              'exclusive-option': zone === 'Полностью всё помещение',
            }"
          >
            <input
              type="checkbox"
              :value="zone"
              v-model="store.answers.step_2"
              class="hidden-checkbox"
              @change="handleZoneChange(zone)"
            />
            <div class="card-icon-placeholder"><IconBox /></div>
            <span class="card-text">{{ zone }}</span>
            <div class="checkbox-indicator">
              <IconCheck v-if="store.answers.step_2.includes(zone)" />
            </div>
          </label>
        </div>
      </div>
      <!-- ШАГ 3: Площадь -->
      <div v-if="store.currentStep === 3" class="step-content">
        <h2>
          Укажите примерную площадь:
          <span class="area-display">{{ store.answers.step_3 }} м²</span>
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

      <!-- ШАГ 4: Стиль (Интерактивные карточки) -->
      <div v-if="store.currentStep === 4" class="step-content">
        <h2>Какой стиль интерьера вам ближе?</h2>
        <div class="options-grid card-grid">
          <label
            v-for="opt in [
              'Современный',
              'Минимализм',
              'Неоклассика',
              'Скандинавский',
              'Лофт',
              'Классика',
              'Пока не определился',
            ]"
            :key="opt"
            class="card-option"
            :class="{ active: store.answers.step_4 === opt }"
            @click="selectStep4(opt)"
          >
            <div class="card-icon-placeholder"><IconBox /></div>
            <span class="card-text">{{ opt }}</span>
          </label>
        </div>
      </div>

      <!-- ШАГ 5: Бюджет -->
      <div v-if="store.currentStep === 5" class="step-content">
        <h2>Какой бюджет вы рассматриваете?</h2>
        <div class="options-grid card-grid">
          <label
            v-for="opt in [
              'До 500 000 ₽',
              '500 000 – 1 000 000 ₽',
              '1 000 000 – 2 000 000 ₽',
              'От 2 000 000 ₽',
              'Пока не знаю',
            ]"
            :key="opt"
            class="card-option"
            :class="{ active: store.answers.step_5 === opt }"
            @click="selectStep5(opt)"
          >
            <div class="card-icon-placeholder"><IconBox /></div>
            <span class="card-text">{{ opt }}</span>
          </label>
        </div>
      </div>

      <!-- ШАГ 6: Контакты -->
      <div v-if="store.currentStep === 6" class="step-content">
        <h2>Оставьте контакты для связи</h2>
        <div class="form-group">
          <input
            v-model="store.contact.name"
            placeholder="Ваше имя *"
            class="input-field"
            :class="{ 'input-error': !store.contact.name && showValidation }"
          />

          <input
            v-model="store.contact.phone"
            placeholder="Телефон: +7 (900) 000-00-00 *"
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
            <span>Согласен на обработку данных *</span>
          </label>
        </div>

        <!-- Сообщение об ошибке отправки (вместо alert) -->
        <p v-if="submitError" class="error-message">⚠️ {{ submitError }}</p>

        <button
          :disabled="loading"
          @click="handleFinalSubmit"
          class="btn-submit"
          :class="{ 'btn-disabled': !isFormValid }"
        >
          {{ loading ? "Отправка..." : "Получить консультацию" }}
        </button>

        <p v-if="!isFormValid" class="validation-hint">
          * Обязательно: Имя, Телефон и Согласие
        </p>
      </div>

      <!-- ЭКРАН УСПЕХА -->
      <div v-if="store.currentStep === 7" class="success-screen">
        <div style="text-align: center">
          <div class="success-icon">🎉</div>
          <h2>Спасибо, {{ store.contact.name }}!</h2>
          <p>Ваша заявка принята. Мы свяжемся с вами в ближайшее время.</p>
          <button
            @click="resetQuiz"
            class="btn-nav btn-next"
            style="margin: 20px auto"
          >
            Вернуться в начало
          </button>
        </div>
      </div>
    </div>

    <div
      class="quiz-footer"
      v-if="store.currentStep > 1 && store.currentStep < 6"
    >
      <button @click="store.prevStep" class="btn-nav">Назад</button>
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
import { ref, computed, watch, onMounted } from "vue";
import { useQuizStore } from "@/stores/useQuizStore";
import { submitQuiz } from "@/api/projects";
import { useAuthStore } from '@/stores/useAuthStore';
import { useRouter } from 'vue-router';
import "@/assets/quiz.css";

const store = useQuizStore();
const loading = ref(false);
const agreed = ref(false);
const submitError = ref("");
const showValidation = ref(false);
const authStore = useAuthStore();
const router = useRouter();

const showStep1Other = ref(false);
const step1OtherValue = ref("");

// --- АНАЛИТИКА (Раздел 12 ТЗ) ---
const trackEvent = (eventName: string) => {
  console.log(`[Analytics] Event: ${eventName}`);
  // Если подключена метрика:
  // if (window.ym) window.ym(XXXXXX, 'reachGoal', eventName);
};

onMounted(() => trackEvent("quiz_start"));

watch(
  () => store.currentStep,
  (newStep) => {
    if (newStep <= 6) trackEvent(`quiz_step_${newStep}`);
    if (newStep === 7) trackEvent("quiz_success");
  },
);

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

const zonesList = [
  "Кухня",
  "Гостиная",
  "Спальня",
  "Детская",
  "Санузел",
  "Прихожая",
  "Кабинет",
  "Гардеробная",
  "Балкон / лоджия",
  "Полностью всё помещение",
];

const handleZoneChange = (lastSelected: string) => {
  const ALL_KEY = "Полностью всё помещение";

  if (lastSelected === ALL_KEY) {
    if (store.answers.step_2.includes(ALL_KEY)) {
      store.answers.step_2 = [...zonesList];
    } else {
      store.answers.step_2 = [];
    }
  } else {
    if (
      store.answers.step_2.includes(ALL_KEY) &&
      !store.answers.step_2.includes(lastSelected)
    ) {
      store.answers.step_2 = store.answers.step_2.filter((z) => z !== ALL_KEY);
    }

    const otherZones = zonesList.filter((z) => z !== ALL_KEY);
    const allOthersSelected = otherZones.every((z) =>
      store.answers.step_2.includes(z),
    );

    if (allOthersSelected && !store.answers.step_2.includes(ALL_KEY)) {
      store.answers.step_2.push(ALL_KEY);
    }
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
  if (store.currentStep === 4) return !!store.answers.step_4;
  if (store.currentStep === 5) return !!store.answers.step_5;
  return false;
});

const isFormValid = computed(() => {
  const phoneDigits = store.contact.phone
    ? store.contact.phone.replace(/\D/g, "")
    : "";
  const nameValid = store.contact.name && store.contact.name.trim().length > 0;
  return phoneDigits.length === 11 && agreed.value && nameValid;
});

const handleFinalSubmit = async () => {
  if (!isFormValid.value) {
    showValidation.value = true;
    return;
  }

  loading.value = true;
  submitError.value = "";
  trackEvent("quiz_submit");

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
    // Оставляем только один корректный вызов
    await submitQuiz(payload);
    store.currentStep = 7;
  } catch (e: any) {
    console.error("Ошибка при отправке квиза:", e);
    submitError.value =
      "Не удалось отправить заявку. Пожалуйста, попробуйте ещё раз.";
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
