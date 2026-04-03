class Api::V1::LeadsController < ApplicationController
  skip_before_action :verify_authenticity_token, raise: false

  def create
    lead = Lead.new(lead_params)
    
    lead.answers = params[:lead][:answers] if params[:lead][:answers].present?

    if lead.save
      NotifyManagerJob.perform_later(lead.id)
      render json: { message: 'Заявка отправлена', lead: lead }, status: :created
    else
      render json: { errors: lead.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def lead_params
    params.require(:lead).permit(
      :name, :phone, :email, :comment, :page_url
    )
  end
end