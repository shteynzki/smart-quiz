import { defineStore } from 'pinia';
import { ref } from 'vue';
import { sendChatMessage } from '@/api/chat';

export interface ChatMessage {
  role: 'system' | 'user' | 'assistant';
  content: string;
}

export const useChatStore = defineStore('chat', () => {
  const messages = ref<ChatMessage[]>([
    { 
      role: 'system', 
      content: 'Ты — профессиональный дизайнер интерьеров компании ITDON. Твоя задача — помогать пользователю заполнить квиз, отвечать кратко, экспертно и вдохновляюще.' 
    },
    { 
      role: 'assistant', 
      content: 'Здравствуйте! Я ваш ИИ-помощник. Чем могу помочь в создании вашего идеального интерьера?' 
    }
  ]);
  
  const isLoading = ref(false);

  const sendMessage = async (content: string) => {
    if (!content.trim() || isLoading.value) return;

    messages.value.push({ role: 'user', content });
    isLoading.value = true;

    try {
      // Отправляем всю историю для сохранения контекста
      const response = await sendChatMessage(messages.value);
      
      messages.value.push({ 
        role: 'assistant', 
        content: response.data.message 
      });
    } catch (error) {
      console.error('Ошибка чата:', error);
      messages.value.push({ 
        role: 'assistant', 
        content: 'Извините, возникли временные трудности со связью. Я скоро вернусь!' 
      });
    } finally {
      isLoading.value = false;
    }
  };

  const clearChat = () => {
    // Сбрасываем к исходному состоянию (оставляем систему и приветствие)
    messages.value = [messages.value[0], messages.value[1]];
  };

  return { messages, isLoading, sendMessage, clearChat };
});