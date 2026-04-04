import { defineStore } from 'pinia'; // <--- ОБЯЗАТЕЛЬНО
import { ref } from 'vue';
import type { QuizAnswers, UserContact } from '@/types/quiz';

export const useQuizStore = defineStore('quiz', () => {
  const currentStep = ref(1);
  
  const answers = ref<QuizAnswers>({
    step_1: '',
    step_2: [],
    step_3: 60,
    step_4: '',
    step_5: '',
  });

  const contact = ref<UserContact>({
    name: '',
    phone: '',
    email: '',
    comment: ''
  });

  const nextStep = () => currentStep.value++;
  const prevStep = () => currentStep.value--;

  return { currentStep, answers, contact, nextStep, prevStep };
});