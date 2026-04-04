import { defineStore } from 'pinia';
import { ref } from 'vue';
import { sendChatMessage } from '@/api/chat';

export interface ChatMessage {
  role: 'user' | 'assistant';
  content: string;
}

export const useChatStore = defineStore('chat', () => {
  const messages = ref<ChatMessage[]>([]);
  const isLoading = ref(false);

  const sendMessage = async (content: string) => {
    if (!content.trim()) return;


    messages.value.push({ role: 'user', content });
    isLoading.value = true;

    try {

      const response = await sendChatMessage(messages.value);
      
     
      messages.value.push({ 
        role: 'assistant', 
        content: response.data.message || response.data.content 
      });
    } catch (error) {
      console.error('Chat Error:', error);
      messages.value.push({ 
        role: 'assistant', 
        content: 'Извините, сейчас я не могу ответить. Попробуйте позже!' 
      });
    } finally {
      isLoading.value = false;
    }
  };

  const clearChat = () => {
    messages.value = [];
  };

  return { messages, isLoading, sendMessage, clearChat };
});