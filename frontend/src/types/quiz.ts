export interface QuizAnswers {
  step_1: string;       // Тип помещения
  step_2: string[];     // Зоны (массив, т.к. выбор множественный)
  step_3: number;       // Площадь
  step_4: string;       // Стиль
  step_5: string;       // Бюджет
}

export interface UserContact {
  name: string;
  phone: string;
  email?: string;
  comment?: string;
}

// Финальный объект для отправки (Lead)
export interface CreateLeadPayload {
  lead: UserContact & {
    answers: QuizAnswers;
    page_url: string;
    utm_source?: string;
  };
}