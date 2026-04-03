class Lead < ApplicationRecord
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

  # --- НОВОЕ: Валидация зон из ТЗ ---
  validate :at_least_one_zone_selected

  private

  def at_least_one_zone_selected
    # Проверяем наличие ключа 'step_2' (или 'zones', смотря как шлет фронт)
    # В твоем фронтенде это store.answers.step_2
    zones = answers&.dig("step_2") || answers&.dig("zones")

    if zones.blank? || (zones.is_a?(Array) && zones.empty?)
      errors.add(:base, "Необходимо выбрать хотя бы одну зону для проектирования")
    end
  end
end
