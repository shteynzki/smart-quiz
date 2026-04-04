<template>
  <div class="quiz-container">
    <div v-if="store.currentStep <= 6" class="progress-section">
      <div class="progress-info">Шаг {{ store.currentStep }} из 6</div>
      <div class="progress-bar">
        <!-- Ширина меняется динамически в зависимости от шага -->
        <div
          class="progress-fill"
          :style="{ width: (store.currentStep / 6) * 100 + '%' }"
        ></div>
      </div>
    </div>

    <div class="quiz-content">
      <!-- ШАГ 1: Тип помещения (без кружочков) -->
      <div v-if="store.currentStep === 1" class="step-content">
        <h2>Какое помещение вы планируете оформить?</h2>
        <div class="options-grid card-grid">
          <label
            v-for="opt in [
              'Квартира',
              'Частный дом',
              'Офис',
              'Коммерция',
              'Студия',
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

      <!-- ШАГ 2: Зоны (с кружочками, множественный выбор) -->
      <div v-if="store.currentStep === 2" class="step-content">
        <h2>Какие зоны нужно включить в проект?</h2>
        <div class="options-grid card-grid">
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
            ] as string[]"
            :key="zone"
            class="card-option"
            :class="{
              active: store.answers.step_2.includes(zone),
              'exclusive-option': zone === 'Полностью всё',
            }"
          >
            <input
              type="checkbox"
              :value="zone"
              v-model="store.answers.step_2"
              class="hidden-checkbox"
              @change="handleZoneChange(zone)"
            />

            <div class="card-icon-placeholder">
              <IconBox />
            </div>

            <span class="card-text">{{ zone }}</span>

            <div class="checkbox-indicator">
              <IconCheck v-if="store.answers.step_2.includes(zone)" />
            </div>
          </label>
        </div>
      </div>

      <!-- ШАГ 3: Площадь (Слайдер) -->
      <div v-if="store.currentStep === 3" class="step-content">
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

      <!-- ШАГ 4: Стиль (без кружочков) -->
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
              'Не определился',
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

      <!-- ШАГ 5: Бюджет (без кружочков) -->
      <div v-if="store.currentStep === 5" class="step-content">
        <h2>Какой бюджет вы рассматриваете?</h2>
        <div class="options-grid card-grid">
          <label
            v-for="opt in [
              'До 500к ₽',
              '500к – 1млн ₽',
              '1млн – 2млн ₽',
              'От 2млн ₽',
              'Не знаю',
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
        <div class="quiz-container" style="text-align: center; margin-top: 0">
          <div
            class="card-icon-placeholder"
            style="color: #28a745; font-size: 4rem"
          >
            🎉
          </div>
          <h2 style="color: var(--text-h)">Спасибо!</h2>
          <p style="color: #718096; margin-bottom: 30px">
            Ваша заявка принята. Мы свяжемся с вами в ближайшее время для
            уточнения деталей.
          </p>
          <button
            @click="resetQuiz"
            class="btn-nav btn-next"
            style="max-width: 250px; margin: 0 auto"
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
import { ref, computed } from "vue";
import { useQuizStore } from "@/stores/useQuizStore";
import { submitQuiz } from "@/api/projects";
import { useAuthStore } from "@/stores/useAuthStore";
import { useRouter } from "vue-router";
import "@/assets/quiz.css";

const store = useQuizStore();
const loading = ref(false);
const agreed = ref(false);
const authStore = useAuthStore();
const router = useRouter();

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
  if (store.currentStep === 4) return !!store.answers.step_4;
  if (store.currentStep === 5) return !!store.answers.step_5;
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
  router.push({ name: "Login" });
};
</script>
