import { apiClient } from './client';

const USE_MOCK = true; // ПОМЕНЯЙ НА false, КОГДА БЭКЕНД ОЖИВЕТ

export const sendChatMessage = async (history: any[]) => {
  if (USE_MOCK) {
    // Имитация ответа бэкенда для тестов верстки
    await new Promise(resolve => setTimeout(resolve, 1000));
    return {
      data: {
        message: "Это тестовый совет от ИИ. На текущем этапе я рекомендую обратить внимание на эргономику пространства!"
      }
    };
  }

  // Реальный запрос к бэкенду
  return await apiClient.post('/chat', { messages: history });
};