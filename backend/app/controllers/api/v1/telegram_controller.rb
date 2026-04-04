class Api::V1::TelegramController < ApplicationController
  skip_before_action :verify_authenticity_token, raise: false

  def webhook
    message = params.dig(:message)

    if message && message[:text].to_s.start_with?("/start ")
      lead_id = message[:text].split(" ")[1]
      chat_id = message.dig(:chat, :id)

      lead = Lead.find_by(id: lead_id)

      if lead
        text = <<~MSG
          Привет, <b>#{lead.name}</b>! 👋
          Вот полная копия твоей заявки:

          📞 <b>Телефон:</b> #{lead.phone}
          ✉️ <b>Email:</b> #{lead.email.presence || 'Не указан'}

          🏠 <b>Помещение:</b> #{lead.answers['room_type'] || 'Не указано'}
          📏 <b>Площадь:</b> #{lead.answers['area'] || '?'} м2
          🛠 <b>Зоны:</b> #{Array(lead.answers['zones']).join(', ').presence || 'Не выбраны'}
          🎨 <b>Стиль:</b> #{lead.answers['style'] || 'Не указан'}
          💰 <b>Бюджет:</b> #{lead.answers['budget'] || 'Не указан'}
          💬 <b>Комментарий:</b> #{lead.comment.presence || 'Нет'}

          Скоро свяжемся с тобой для уточнения деталей!
        MSG

        send_message(chat_id, text)
      else
        send_message(chat_id, "К сожалению, заявка не найдена.")
      end
    end

    head :ok
  end

  private

  def send_message(chat_id, text)
    token = ENV["TELEGRAM_BOT_TOKEN"]
    uri = URI.parse("https://api.telegram.org/bot#{token}/sendMessage")

    Net::HTTP.post_form(uri, chat_id: chat_id, text: text, parse_mode: "HTML")
  end
end
