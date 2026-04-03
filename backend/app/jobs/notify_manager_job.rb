require "net/http"
require "uri"

class NotifyManagerJob < ApplicationJob
  queue_as :default

  def perform(lead_id)
    lead = Lead.find_by(id: lead_id)
    return unless lead

    # 1. Формируем красивый текст сообщения
    # Используем данные из обычных колонок и из JSON-колонки answers
    text = <<~MSG
      🚀 <b>НОВАЯ ЗАЯВКА ИЗ КВИЗА!</b>

      👤 <b>Клиент:</b> #{lead.name}
      📞 <b>Телефон:</b> #{lead.phone}
      ✉️ <b>Email:</b> #{lead.email.presence || 'Не указан'}

      🏠 <b>Помещение:</b> #{lead.answers['step_1'] || 'Не указано'}
      📏 <b>Площадь:</b> #{lead.answers['step_3'] || '?'} м2
      🛠 <b>Зоны:</b> #{Array(lead.answers['step_2']).join(', ').presence || 'Не выбраны'}
      🎨 <b>Стиль:</b> #{lead.answers['step_4'] || 'Не указан'}
      💰 <b>Бюджет:</b> #{lead.answers['step_5'] || 'Не указан'}
      💬 <b>Комментарий:</b> #{lead.comment.presence || 'Нет'}

      🔗 <b>Источник:</b> #{lead.page_url || 'Не указан'}
      🕒 <b>Дата и время:</b> #{lead.created_at.in_time_zone('Moscow').strftime('%d.%m.%Y в %H:%M')}
    MSG

    # 2. Выводим текст в консоль сервера (для удобства отладки)
    puts "============================================="
    puts text
    puts "============================================="

    # 3. Реальная отправка в Telegram
    # Токены мы будем брать из переменных окружения .env (чтобы не светить их в коде)
    bot_token = ENV["TELEGRAM_BOT_TOKEN"]
    chat_id = ENV["TELEGRAM_CHAT_ID"]

    if bot_token.present? && chat_id.present?
      send_to_telegram(bot_token, chat_id, text)
    else
      puts "⚠️ Токен Telegram не настроен в .env. Сообщение выведено только в логи."
    end
    LeadMailer.new_lead_email(lead).deliver_later
  end

  private

  def send_to_telegram(token, chat_id, text)
    uri = URI.parse("https://api.telegram.org/bot#{token}/sendMessage")

    # Отправляем POST-запрос к API Telegram
    response = Net::HTTP.post_form(uri,
      chat_id: chat_id,
      text: text,
      parse_mode: "HTML"
    )

    unless response.is_a?(Net::HTTPSuccess)
      Rails.logger.error "Ошибка отправки в ТГ: #{response.body}"
    end
  rescue StandardError => e
    Rails.logger.error "Сетевая ошибка при отправке в ТГ: #{e.message}"
  end
end
