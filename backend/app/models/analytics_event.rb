class AnalyticsEvent < ApplicationRecord
  # 1. Валидации: не даем сохранить пустое событие
  validates :event_type, presence: true
  validates :session_id, presence: true

  # 2. Удобные фильтры (Scopes)
  # Позволят писать AnalyticsEvent.quiz_starts вместо длинных запросов
  scope :quiz_starts, -> { where(event_type: 'quiz_start') }
  scope :submissions, -> { where(event_type: 'quiz_submit') }
  
  # 3. Метод для быстрой аналитики (опционально)
  # Поможет в консоли быстро глянуть воронку
  def self.stats
    group(:event_type).count
  end
end