class Api::V1::ChatController < ApplicationController
  skip_before_action :verify_authenticity_token, raise: false

  def create
    client = OpenAI::Client.new(
      access_token: ENV.fetch("NVIDIA_API_KEY"),
      uri_base: ENV.fetch("NVIDIA_URL"),
      request_timeout: 60
    )

    messages = params[:messages].map do |msg|
      { role: msg[:role], content: msg[:content] }
    end

    response = client.chat(
      parameters: {
        model: ENV.fetch("NVIDIA_MODEL", "nvidia/nemotron-3-super-120b-a12b"),
        messages: messages,
        temperature: 0.5,
        max_tokens: 1024,
        top_p: 1
      }
    )

    if response && response["choices"]
      ai_message = response.dig("choices", 0, "message", "content")
      if messages.any?
  AnalyticsEvent.create(
    event_type: "ai_chat_interaction",
    session_id: request.remote_ip,
    payload: {
      user_query: messages.last[:content],
      ai_response: ai_message
    }
  )
      end
      render json: { message: ai_message }
    else
      Rails.logger.error "NVIDIA Error Detail: #{response['error'] || 'Unknown error'}"
      render json: { error: "Нейросеть временно недоступна" }, status: :service_unavailable
    end
  rescue StandardError => e
    Rails.logger.error "Chat Error: #{e.message}"
    render json: { error: "Внутренняя ошибка сервера" }, status: :internal_server_error
  end
end
