class Api::V1::LeadsController < ApplicationController
  skip_before_action :verify_authenticity_token, raise: false

  def create
    lead = Lead.new(lead_params)
    
    if lead.save
      render json: { message: 'Заявка успешно отправлена', lead: lead }, status: :created
    else
      render json: { errors: lead.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def lead_params
    params.require(:lead).permit(:name, :phone, :email, answers: {})
  end
end