
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


export const sendEmailConfirmation = async (leadId: number): Promise<any> => {
  if (import.meta.env.VITE_USE_MOCKS === 'true') {
    await new Promise(resolve => setTimeout(resolve, 800));
    console.log(`--- MOCK EMAIL SENT FOR LEAD: ${leadId} ---`);
    return { status: 200, data: { message: "Mock email sent" } };
  }

  return await apiClient.post(`/leads/${leadId}/confirm_email`);
};