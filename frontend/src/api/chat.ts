import { apiClient } from './client';
import type { ChatMessage } from '@/stores/useChatStore';

export const sendChatMessage = async (history: ChatMessage[]) => {
  return await apiClient.post('/chat', { messages: history });
};