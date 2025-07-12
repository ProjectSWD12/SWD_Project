// api.ts
// Axios instance and API calls for the backend.
import axios from 'axios';

const API_BASE_URL = '/api';

const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

export interface Guide {
  id: string;
  name: string;
  avatar: string;
  bio: string;
  createdAt: string;
  email: string;
  level: string;
  phone: string;
  telegramAlias: string;
  excursionsDone: number;
}

export interface Excursion {
  id: string;
  assignedTo: string;
  date: string;
  lunch: boolean;
  masterClass: boolean;
  meetingPlace: string;
  people: number;
  route: string;
  time: string;
  type: string;
}
export interface Company{
    id:string;
    address: string;
    name: string;
    createdAt: string;
    email: string;
    phone: string;
    banList: Array<string>;
}

export interface CreateGuideData {
  name: string;
  avatar: string;
  bio: string;
  createdAt: string;
  email: string;
  level: string;
  phone: string;
  telegramAlias: string;
  excursionsDone?: number;
}

export interface CreateCompanyData{
  address: string;
  name: string;
  createdAt: string;
  email: string;
  phone: string;
  banList: Array<string>;
}

export interface CreateExcursionData {
  assignedTo: string;
  date: string;
  lunch: boolean;
  masterClass: boolean;
  meetingPlace: string;
  people: number;
  route: string;
  time: string;
  type: string;
}

//Customers
export const fetchCompanies = async(): Promise<Company[]> =>{
  const response = await api.get('/companies');
  return response.data;
};

export const createCompany = async (companyData: CreateCompanyData): Promise<Company> => {
  const response = await api.post('/companies', companyData);
  return response.data;
};

export const fetchCompany = async(id: string): Promise<Company> =>{
  const response = await api.get(`/companies/${id}`);
  return response.data;
};

// Guides
export const fetchGuides = async (): Promise<Guide[]> => {
  const response = await api.get('/guides');
  return response.data;
};

export const createGuide = async (guideData: CreateGuideData): Promise<Guide> => {
  const response = await api.post('/guides', guideData);
  return response.data;
};

// Excursions
export const fetchExcursions = async (): Promise<Excursion[]> => {
  const response = await api.get('/excursions');
  return response.data;
};

export const fetchExcursion = async (id: string): Promise<Excursion> => {
  const response = await api.get(`/excursions/${id}`);
  return response.data;
};

export const createExcursion = async (excursionData: CreateExcursionData): Promise<Excursion> => {
  const response = await api.post('/excursions', excursionData);
  return response.data;
};

export const updateExcursion = async (id: string, excursionData: CreateExcursionData): Promise<Excursion> => {
  const response = await api.put(`/excursions/${id}`, excursionData);
  return response.data;
};

export const deleteExcursion = async (id: string): Promise<void> => {
  await api.delete(`/excursions/${id}`);
};

export default api;