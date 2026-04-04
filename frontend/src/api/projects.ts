// src/api/projects.ts
import { apiClient } from './client';
import type { CreateLeadPayload } from '@/types/quiz';

export const submitQuiz = async (payload: CreateLeadPayload): Promise<any> => {
  if (import.meta.env.VITE_USE_MOCKS === 'true') {
    await new Promise(resolve => setTimeout(resolve, 1000));
    console.log('--- MOCK SUBMIT SUCCESS ---', payload);
    return { 
      status: 201, 
      data: { id: 999, message: "Mock success" } 
    };
  }

  return await apiClient.post('/leads', payload);
};