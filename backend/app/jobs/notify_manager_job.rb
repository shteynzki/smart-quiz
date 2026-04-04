require "net/http"
require "uri"
require "timeout"

class NotifyManagerJob < ApplicationJob
  queue_as :default
retry_on StandardError, wait: 3.seconds, attempts: 3
  def perform(lead_id)
    lead = Lead.find_by(id: lead_id)
    return unless lead

    text = <<~MSG
      🚀 <b>НОВАЯ ЗАЯВКА ИЗ КВИЗА!</b>

      👤 <b>Клиент:</b> #{lead.name}
      📞 <b>Телефон:</b> #{lead.phone}
      ✉️ <b>Email:</b> #{lead.email.presence || 'Не указан'}

      🏠 <b>Помещение:</b> #{lead.answers['room_type'] || 'Не указано'}
      📏 <b>Площадь:</b> #{lead.answers['area'] || '?'} м2
      🛠 <b>Зоны:</b> #{Array(lead.answers['zones']).join(', ').presence || 'Не выбраны'}
      🎨 <b>Стиль:</b> #{lead.answers['style'] || 'Не указан'}
      💰 <b>Бюджет:</b> #{lead.answers['budget'] || 'Не указан'}
      💬 <b>Комментарий:</b> #{lead.comment.presence || 'Нет'}

      🔗 <b>Источник:</b> #{lead.page_url || 'Не указан'}
      🕒 <b>Дата и время:</b> #{lead.created_at.in_time_zone('Moscow').strftime('%d.%m.%Y в %H:%M')}
    MSG

    puts "============================================="
    puts text
    puts "============================================="

    bot_token = ENV["TELEGRAM_BOT_TOKEN"]
    chat_id = ENV["TELEGRAM_CHAT_ID"]

    if bot_token.present? && chat_id.present?
      send_to_telegram(bot_token, chat_id, text)
    else
      puts "=====Токен Telegram не настроен в .env. Сообщение выведено только в логи.====="
    end
    LeadMailer.new_lead_email(lead).deliver_later
  end

  private

  def send_to_telegram(token, chat_id, text)
    uri = URI.parse("https://api.telegram.org/bot#{token}/sendMessage")

    Timeout.timeout(5) do
      response = Net::HTTP.post_form(uri, chat_id: chat_id, text: text, parse_mode: "HTML")
      unless response.is_a?(Net::HTTPSuccess)
        Rails.logger.error "======Ошибка отправки в Telegram: #{response.body}====="
      end
    end
  rescue Timeout::Error
    Rails.logger.error "=====Таймаут: сервер Telegram не ответил вовремя====="
  rescue StandardError => e
    Rails.logger.error "=====Сетевая ошибка при отправке в Telegram: #{e.message}====="
  end
end
