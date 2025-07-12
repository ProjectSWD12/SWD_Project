// ManageUsersModal.tsx
// Modal window for viewing and adding users.
import React from 'react';
import { useForm } from 'react-hook-form';
import { useMutation, useQueryClient, useQuery } from 'react-query';
import { X, User as UserIcon, MessageCircle } from 'lucide-react';
import { useLanguage } from '../contexts/LanguageContext';
import { createGuide, CreateGuideData, fetchGuides, Guide } from '../services/api';
import './ManageUsersModal.css';

interface ManageUsersModalProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
}

const ManageUsersModal: React.FC<ManageUsersModalProps> = ({ open, onOpenChange }) => {
  const { t } = useLanguage();
  const queryClient = useQueryClient();
  const { register, handleSubmit, reset, formState: { errors } } = useForm<CreateGuideData>();

  const { data: users = [], isLoading } = useQuery('guides', fetchGuides);

  const createUserMutation = useMutation(createGuide, {
    onSuccess: () => {
      queryClient.invalidateQueries('guides');
      reset();
    }
  });

  const onSubmit = (data: CreateGuideData) => {
    createUserMutation.mutate({
      ...data,
      excursionsDone: Number(data.excursionsDone || 0),
      avatar: data.avatar || '',
      bio: data.bio || '',
      createdAt: data.createdAt || new Date().toISOString(),
      email: data.email || '',
      level: data.level || '',
      phone: data.phone || ''
    });
  };

  if (!open) return null;

  return (
    <div className="modal-overlay">
      <div className="modal-content large">
        <div className="modal-header">
          <h2>Управление гидами</h2>
          <button onClick={() => onOpenChange(false)} className="close-button">
            <X size={20} />
          </button>
        </div>

        <div className="modal-body">
          <div className="users-section">
            <h3>Текущие гиды</h3>
            {isLoading ? (
              <div className="loading">Загружаем гидов...</div>
            ) : (
              <div className="users-list">
                {users.length === 0 ? (
                  <p className="no-users">Ни одного гида в системе не зарешистрировано. Добавьте первого, заполнив форму</p>
                ) : (
                  users.map((guide: Guide) => (
                    <div key={guide.id} className="user-item">
                      <div className="user-info">
                        <h4>{guide.name}</h4>
                        <div className="user-details">
                          {guide.telegramAlias && <span><MessageCircle size={14} /> @{guide.telegramAlias}</span>}
                          <span className="excursions-done">{guide.excursionsDone} excursions</span>
                        </div>
                      </div>
                    </div>
                  ))
                )}
              </div>
            )}
          </div>

          <div className="add-user-section">
            <h3>Добавить нового гида</h3>
            <form onSubmit={handleSubmit(onSubmit)} className="user-form">
              <div className="form-row">
                <div className="form-group">
                  <label htmlFor="name">ФИО</label>
                  <div className="input-with-icon">
                    <UserIcon size={16} />
                    <input id="name" {...register('name', { required: 'Введите ФИО' })} />
                  </div>
                  {errors.name && <span className="error">{errors.name.message}</span>}
                </div>

                <div className="form-group">
                  <label htmlFor="telegram">Телеграм</label>
                  <div className="input-with-icon">
                    <MessageCircle size={16} />
                    <input id="telegramAlias" {...register('telegramAlias', { required: 'Введите телеграмм контакт гида' })} placeholder="telegram_username" />
                  </div>
                  {errors.telegramAlias && <span className="error">{errors.telegramAlias.message}</span>}
                </div>
              </div>

              <div className="form-group">
                <label htmlFor="excursionsDone">Экскурсий проведено</label>
                <input
                  id="excursionsDone"
                  type="number"
                  defaultValue={0}
                  {...register('excursionsDone')}
                />
              </div>

              <div className="form-actions">
                <button type="submit" disabled={createUserMutation.isLoading} className="submit-button">
                  {createUserMutation.isLoading ? 'Добавляем...' : 'Добавить гида'}
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  );
};

export default ManageUsersModal;