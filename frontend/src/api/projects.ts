import { apiClient } from './client';
import { delay } from './utils';

export interface Project {
  id: number;
  title: string;
  status: 'active' | 'completed';
}

// МОК-функция
const fetchProjectsMock = async (): Promise<Project[]> => {
  await delay(800);
  
  return [
    { id: 1, title: "Сделать дизайн", status: "completed" },
    { id: 2, title: "Настроить сервер", status: "active" },
    { id: 3, title: "Написать питч", status: "active" }
  ];
};

const fetchProjectsReal = async (): Promise<Project[]> => {
  const response = await apiClient.get('/projects');
  return response.data;
};

export const fetchProjects = import.meta.env.VITE_USE_MOCKS === 'true' 
  ? fetchProjectsMock 
  : fetchProjectsReal;