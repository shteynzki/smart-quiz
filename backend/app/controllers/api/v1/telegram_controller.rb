class Api::V1::TelegramController < ApplicationController
  skip_before_action :verify_authenticity_token, raise: false

  def webhook
    message = params.dig(:message)
    
    if message && message[:text].to_s.start_with?('/start ')
      lead_id = message[:text].split(' ')[1] # Достаем ID (например, 28)
      chat_id = message.dig(:chat, :id)

      lead = Lead.find_by(id: lead_id)

      if lead
        text = "Привет, #{lead.name}! 👋\nВот копия твоей заявки:\n\nПомещение: #{lead.answers['room_type']}\nПлощадь: #{lead.answers['area']} м²\nСтиль: #{lead.answers['style']}\nБюджет: #{lead.answers['budget']}\n\nСкоро свяжемся!"
        send_message(chat_id, text)
      else
        send_message(chat_id, "К сожалению, заявка не найдена.")
      end
    end

    head :ok # Обязательно отвечаем Telegram, что все ок
  end

  private

  def send_message(chat_id, text)
    token = ENV["TELEGRAM_BOT_TOKEN"]
    uri = URI.parse("https://api.telegram.org/bot#{token}/sendMessage")
    Net::HTTP.post_form(uri, chat_id: chat_id, text: text)
  end
end