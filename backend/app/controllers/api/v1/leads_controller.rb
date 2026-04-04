class Api::V1::LeadsController < ApplicationController
  skip_before_action :verify_authenticity_token, raise: false

  def create
    # Теперь lead_params сразу содержит и обычные поля, и answers
    lead = Lead.new(lead_params)

    # Фиксация события для аналитики (п. 12 ТЗ)
    Rails.logger.info "QUIZ_EVENT: submit | IP: #{request.remote_ip}"

    if lead.save
      NotifyManagerJob.perform_later(lead.id)

      # Лог успеха
      Rails.logger.info "QUIZ_EVENT: success | Lead ID: #{lead.id}"

      render json: { message: "Заявка успешно отправлена", lead: lead }, status: :created
    else
      # Лог ошибки
      Rails.logger.warn "QUIZ_EVENT: validation_error | Errors: #{lead.errors.full_messages}"

      render json: { errors: lead.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def index
    # В идеале здесь должна быть проверка токена администратора!
    leads = Lead.all
    
    # Безопасный способ для API-only контроллеров (без respond_to)
    if request.format.csv?
      send_data leads.to_csv, filename: "leads-#{Date.today}.csv"
    else
      render json: leads
    end
  end

  private

  def lead_params
    params.require(:lead).permit(
      :name, :phone, :email, :comment, :page_url, :consent,
      :utm_source, :utm_medium, :utm_campaign, :utm_content, :utm_term,
      # Явно описываем структуру jsonb
      answers: [
        :step_1, :step_3, :step_4, :step_5,
        step_2: [] # Пустые скобки говорят Rails: "Тут будет массив, пропусти его"
      ]
    )
  end
end