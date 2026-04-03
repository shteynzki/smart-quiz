class Api::V1::LeadsController < ApplicationController
  skip_before_action :verify_authenticity_token, raise: false

  def create
    permitted = lead_params

     lead = Lead.new(
      name: permitted[:name],
      phone: permitted[:phone],
      email: permitted[:email],
      answers: permitted.except(:name, :phone, :email).to_h
    )
    
    if lead.save
        NotifyManagerJob.perform_later(lead.id)
      render json: { message: 'Спасибо! Ваша заявка отправлена. Мы свяжемся с вами в ближайшее время.', lead: lead }, status: :created
    else
      render json: { errors: lead.errors.full_messages, message: 'Не удалось отправить заявку. Пожалуйста, попробуйте ещё раз.' }, status: :unprocessable_entity
    end
  end

  private

  def lead_params
    params.permit(
      :name, :phone, :email, 
      :room_type, :area, :style, :budget, :comment, 
      :page_url, :utm_source, 
      zones: [] # Разрешаем массив выбранных зон
    )
  end
end