class Api::V1::LeadsController < ApplicationController
  skip_before_action :verify_authenticity_token, raise: false
def create
    result = Leads::CreateLeadService.call(lead_params, request.remote_ip)

    if result.success?
      render json: {
        message: "Заявка успешно отправлена",
        id: result.lead.id
      }, status: :created
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end

def index
    secret = ENV.fetch("LEADS_REPORT_SECRET", "supersecret")
  return render json: { error: "Forbidden" }, status: :forbidden unless params[:secret] == secret

  leads = Lead.all.order(created_at: :desc)

    if request.format.csv?
      send_data leads.to_csv, filename: "leads-#{Date.today}.csv"
    else
      @pagy, @records = pagy(leads)
      render json: {
        data: @records,
        meta: {
          current_page: @pagy.page,
          total_pages: @pagy.pages,
          total_count: @pagy.count,
          items_per_page: @pagy.items
        }
      }
    end
  end

  def confirm_email
    lead = Lead.find_by(id: params[:id])

    if lead && lead.email.present?
      LeadMailer.client_copy_email(lead).deliver_later
      render json: { message: "Письмо успешно отправлено" }, status: :ok
    else
      render json: { error: "Лид не найден или email не указан" }, status: :unprocessable_entity
    end
  end

  private

 def lead_params
  params.require(:lead).permit(
    :name, :phone, :email, :comment, :page_url, :consent,
    :utm_source, :utm_medium, :utm_campaign, :utm_content, :utm_term,
    answers: {}
  )
end
end
