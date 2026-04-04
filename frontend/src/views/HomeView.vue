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

      <div v-if="store.currentStep === 4" class="step-content">
        <h2>Какой стиль интерьера вам ближе?</h2>
        <div class="style-grid">
          <div
            v-for="style in styleOptions"
            :key="style.name"
            class="style-card"
            :class="{ active: store.answers.step_4 === style.name }"
            @click="selectStep4(style.name)"
          >
            <div class="style-image-container">
              <img
                :src="getStyleImage(style.image)"
                :alt="style.name"
                class="style-image"
              />
              <div
                class="style-check-badge"
                v-if="store.answers.step_4 === style.name"
              >
                <IconCheck />
              </div>
            </div>
            <span class="style-label">{{ style.name }}</span>
          </div>
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

          <div class="phone-input-group" style="display: flex; gap: 8px">
            <select
              v-model="countryCode"
              class="input-field"
              style="width: 110px; padding: 0 10px"
            >
              <option value="+7">🇷🇺 +7</option>
              <option value="+375">🇧🇾 +375</option>
              <option value="+77">🇰🇿 +7</option>
              <option value="+995">🇬🇪 +995</option>
              <option value="">🌐 Другое</option>
            </select>
            <input
              v-model="rawPhone"
              placeholder="(900) 000-00-00 *"
              class="input-field"
              type="tel"
              style="flex: 1"
              :class="{ 'input-error': !isPhoneValid && showValidation }"
            />
          </div>

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

          <!-- КАРТОЧКА СОХРАНЕНИЯ -->
          <div
            class="save-results-card"
            style="
              margin: 30px auto;
              max-width: 400px;
              padding: 20px;
              background: var(--bg);
              border: 1px solid var(--border);
              border-radius: 8px;
              text-align: left;
            "
          >
            <h3 style="margin-top: 0; font-size: 1.1rem; color: var(--primary)">
              Сохранить копию ответов:
            </h3>

            <div
              style="
                display: flex;
                flex-direction: column;
                gap: 10px;
                margin-top: 15px;
              "
            >
              <button
                @click="downloadAnswers"
                class="btn-option"
                style="
                  margin: 0;
                  justify-content: center;
                  background: var(--white);
                "
              >
                💾 Скачать текстовый файл
              </button>

              <a
                v-if="createdLeadId"
                :href="`https://t.me/my_smart_quiz_bot?start=${createdLeadId}`"
                target="_blank"
                class="btn-option"
                style="
                  margin: 0;
                  text-decoration: none;
                  text-align: center;
                  background-color: #2aabee;
                  color: white;
                  border-color: #2aabee;
                  justify-content: center;
                "
              >
                ✈️ Получить в Telegram
              </a>

              <!-- Кнопка отправки на почту (появляется только если email не пустой) -->
              <div
                v-if="store.contact.email && store.contact.email.includes('@')"
                style="margin-top: 10px"
              >
                <!-- Кнопка действия (скрывается после успешной отправки) -->
                <button
                  v-if="!emailSent"
                  @click="triggerEmailSend"
                  :disabled="isEmailSending"
                  class="btn-option"
                  style="
                    margin: 0;
                    justify-content: center;
                    background: #f3f4f6; /* Светло-серый фон для отличия */
                    border: 1px solid #d1d5db;
                    width: 100%;
                    cursor: pointer;
                    transition: all 0.2s;
                  "
                  :style="isEmailSending ? 'opacity: 0.7;' : ''"
                >
                  <span v-if="!isEmailSending"
                    >📩 Подтвердить отправку на почту</span
                  >
                  <span v-else>⏳ Отправляем письмо...</span>
                </button>

                <!-- Сообщение об успехе -->
                <div
                  v-else
                  style="
                    text-align: center;
                    color: #10b981;
                    font-weight: 500;
                    font-size: 0.95rem;
                    padding: 10px;
                    background: #ecfdf5;
                    border-radius: 6px;
                  "
                >
                  ✅ Результаты отправлены на {{ store.contact.email }}
                </div>

                <!-- Текст ошибки, если что-то пошло не так -->
                <p
                  v-if="emailError"
                  style="
                    color: #ef4444;
                    font-size: 0.8rem;
                    text-align: center;
                    margin-top: 5px;
                  "
                >
                  {{ emailError }}
                </p>
              </div>
            </div>
          </div>

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
    <ChatWidget v-if="store.currentStep >= 1 && store.currentStep <= 6" />
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch, onMounted } from "vue";
import { useQuizStore } from "@/stores/useQuizStore";
import { submitQuiz } from "@/api/projects";
import { apiClient } from "@/api/client";
import { useAuthStore } from "@/stores/useAuthStore";
import { useRouter } from "vue-router";
import "@/assets/quiz.css";

import ChatWidget from "@/components/ChatWidget.vue"; // Импортируем
import { useChatStore } from "@/stores/useChatStore";

const chatStore = useChatStore(); // Инициализируем

// --- 1. Инициализация и основные состояния ---
const store = useQuizStore();
const authStore = useAuthStore();
const router = useRouter();

const loading = ref(false);
const agreed = ref(false);
const submitError = ref("");
const showValidation = ref(false);
const createdLeadId = ref<number | null>(null);

// Состояния для телефона
const countryCode = ref("+7");
const rawPhone = ref("");

// Состояния для Шага 1 (свой вариант)
const showStep1Other = ref(false);
const step1OtherValue = ref("");

// Состояния для Email (Исправлено: объявлены один раз)
const emailSent = ref(false);
const isEmailSending = ref(false);
const emailError = ref("");

// --- 2. Справочные данные ---
const styleOptions = [
  { name: "Современный", image: "modern.png" },
  { name: "Минимализм", image: "contemporary.png" },
  { name: "Неоклассика", image: "neoclass.png" },
  { name: "Скандинавский", image: "scandinav.png" },
  { name: "Лофт", image: "loft.png" },
  { name: "Классика", image: "classical.png" },
  { name: "Пока не определился", image: "login.png" },
];

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

// --- 3. Вспомогательные функции ---
const getStyleImage = (name: string) => {
  return new URL(`../assets/${name}`, import.meta.url).href;
};

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

const trackEvent = (eventName: string) => {
  console.log(`[Analytics] Event: ${eventName}`);
};

// --- 4. Логика шагов ---
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
  if (step1OtherValue.value.trim().length > 0) {
    store.answers.step_1 = step1OtherValue.value;
    showStep1Other.value = false;
    store.nextStep();
  }
};

const handleZoneChange = (lastSelected: string) => {
  const ALL_KEY = "Полностью всё помещение";
  if (lastSelected === ALL_KEY) {
    store.answers.step_2 = store.answers.step_2.includes(ALL_KEY)
      ? [...zonesList]
      : [];
  } else {
    store.answers.step_2 = store.answers.step_2.filter((z) => z !== ALL_KEY);
    const others = zonesList.filter((z) => z !== ALL_KEY);
    if (others.every((z) => store.answers.step_2.includes(z))) {
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

// --- 5. Вычисляемые свойства (Валидация) ---
const isNextVisible = computed(() => {
  if (store.currentStep === 1)
    return !showStep1Other.value || step1OtherValue.value.length > 0;
  if (store.currentStep === 2) return store.answers.step_2.length > 0;
  if (store.currentStep === 3) return true;
  if (store.currentStep === 4) return !!store.answers.step_4;
  if (store.currentStep === 5) return !!store.answers.step_5;
  return false;
});

const isPhoneValid = computed(
  () => rawPhone.value.replace(/\D/g, "").length >= 9,
);

const isFormValid = computed(() => {
  const nameValid = store.contact.name?.trim().length > 0;
  return isPhoneValid.value && agreed.value && nameValid;
});

// --- 6. Работа с API ---
const handleFinalSubmit = async () => {
  if (!isFormValid.value) {
    showValidation.value = true;
    return;
  }

  loading.value = true;
  submitError.value = "";

  // Собираем телефон
  store.contact.phone = `${countryCode.value} ${rawPhone.value.trim()}`;

  // Формируем тот самый payload, которого не хватало
  const payload = {
    lead: {
      ...store.contact,
      answers: store.answers,
      page_url: window.location.href,
      ...getUtms(),
    },
  };

  try {
    const response = await submitQuiz(payload);

    // Проверяем успешность (обычно 200 или 201)
    if (response.status === 200 || response.status === 201) {
      // КРИТИЧНО: сохраняем ID для Телеграма и Почты
      createdLeadId.value =
        response.data?.id || response.data?.lead?.id || null;

      store.currentStep = 7;
      chatStore.clearChat();
      trackEvent("quiz_success");
    }
  } catch (e: any) {
    console.error(e);
    submitError.value = "Ошибка при отправке. Попробуйте еще раз.";
  } finally {
    loading.value = false;
  }
};

const triggerEmailSend = async () => {
  if (!store.contact.email || !createdLeadId.value) return;
  isEmailSending.value = true;
  emailError.value = "";
  try {
    await apiClient.post("/send-email", {
      email: store.contact.email,
      id: createdLeadId.value,
    });
    emailSent.value = true;
  } catch (err) {
    emailError.value = "Ошибка отправки письма.";
  } finally {
    isEmailSending.value = false;
  }
};

onst downloadAnswers = () => {
  // Формируем красивый текст из всех данных стора
  const summary = `
Ваша заявка на дизайн-проект:
--------------------------------------
Имя: ${store.contact.name}
Телефон: ${store.contact.phone}
Email: ${store.contact.email || 'не указан'}

Помещение: ${store.answers.step_1}
Зоны: ${Array.isArray(store.answers.step_2) ? store.answers.step_2.join(', ') : store.answers.step_2}
Площадь: ${store.answers.step_3} м²
Стиль: ${store.answers.step_4}
Бюджет: ${store.answers.step_5}
Комментарий: ${store.contact.comment || 'нет'}
--------------------------------------
Дата: ${new Date().toLocaleString()}
  `.trim();

  const blob = new Blob([summary], { type: "text/plain" });
  const link = document.createElement("a");
  link.href = URL.createObjectURL(blob);
  link.download = `Заявка_${store.contact.name}.txt`;
  link.click();
};

const resetQuiz = () => {
  // Используем authStore и router, чтобы TS не выдавал ошибку unused variable
  authStore.logout?.();
  router.push("/").then(() => window.location.reload());
};

onMounted(() => trackEvent("quiz_start"));

watch(
  () => store.currentStep,
  (step) => {
    if (step === 6) trackEvent("quiz_form_view");
    else if (step < 6) trackEvent(`quiz_step_${step}`);
  },
);
</script>
