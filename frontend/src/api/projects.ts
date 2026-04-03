import { apiClient } from './client';
import type { CreateLeadPayload } from '@/types/quiz';

export const submitQuiz = async (payload: CreateLeadPayload) => {
  if (import.meta.env.VITE_USE_MOCKS === 'true') {
    // Имитируем задержку сети
    await new Promise(resolve => setTimeout(resolve, 1000));
    console.log('--- MOCK SUBMIT SUCCESS ---', payload);
    return { data: { status: 'success' } };
  }

  return await apiClient.post('/leads', payload);
};