require 'csv' # <--- Обязательно добавляем для работы экспорта

class Lead < ApplicationRecord
  # Виртуальный атрибут для чекбокса согласия (не сохраняется в БД, нужен только для валидации)
  attr_accessor :consent

  validates :name, presence: { message: "обязательно для заполнения" }

  validates :phone,
            presence: { message: "обязателен для заполнения" },
            format: {
              with: /\A\+?[\d\s\-\(\)]+\z/,
              message: "имеет неверный формат (допускаются только цифры, +, пробелы, скобки и дефисы)"
            },
            length: { minimum: 7, maximum: 20, message: "слишком короткий или длинный" }

  validates :email,
            format: { with: URI::MailTo::EMAIL_REGEXP, message: "имеет неверный формат" },
            allow_blank: true

  # Валидация чекбокса (согласие)
  validates :consent, acceptance: { accept: ['true', true, '1', 1], message: "необходимо согласие на обработку данных" }

  # Валидация всех шагов квиза (заменяет старый метод at_least_one_zone_selected)
  validate :all_quiz_steps_present

  def self.to_csv
    # Заголовки колонок в файле
    headers = %w[ID Имя Телефон Email Помещение Зоны Площадь Стиль Бюджет Комментарий Дата UTM_Source]

    CSV.generate(headers: true) do |csv|
      csv << headers
      all.order(created_at: :desc).each do |lead|
        csv << [
          lead.id,
          lead.name,
          lead.phone,
          lead.email,
          lead.answers['room_type'],
          Array(lead.answers['zones']).join(', '),
          lead.answers['area'],
          lead.answers['style'],
          lead.answers['budget'],
          lead.comment,
          lead.created_at.in_time_zone('Moscow').strftime('%d.%m.%Y %H:%M'),
          lead.utm_source
        ]
      end
    end
  end # <--- ЗДЕСЬ НЕ ХВАТАЛО END

  # Перехватываем данные от контроллера и меняем "step_1" на "room_type" и т.д.
  def answers=(incoming_answers)
    if incoming_answers.is_a?(Hash)
      mapping = {
        'step_1' => 'room_type',
        'step_2' => 'zones',
        'step_3' => 'area',
        'step_4' => 'style',
        'step_5' => 'budget'
      }
      
      # Формируем новый хэш с красивыми ключами
      mapped_answers = incoming_answers.transform_keys { |key| mapping[key] || key }
      super(mapped_answers) # Сохраняем в БД уже переведенные ключи
    else
      super(incoming_answers)
    end
  end

  private

  # Проверяем, что теперь в наших "красивых" ключах есть данные для каждого шага
  def all_quiz_steps_present
    return errors.add(:answers, "не могут быть пустыми") if answers.blank?

    errors.add(:base, "Не указан тип помещения") if answers['room_type'].blank?
    
    zones = answers['zones']
    if zones.blank? || (zones.is_a?(Array) && zones.empty?)
      errors.add(:base, "Необходимо выбрать хотя бы одну зону для проектирования")
    end
    
    errors.add(:base, "Не указана площадь") if answers['area'].blank?
    errors.add(:base, "Не указан стиль") if answers['style'].blank?
    errors.add(:base, "Не указан бюджет") if answers['budget'].blank?
  end
end