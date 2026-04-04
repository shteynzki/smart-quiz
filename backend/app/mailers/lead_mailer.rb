class LeadMailer < ApplicationMailer
  # ENV.fetch возьмет email из .env, а если его там нет — подставит admin@example.com
  default to: -> { ENV.fetch("MANAGER_EMAIL", "manager@example.ru") }

  def new_lead_email(lead)
    @lead = lead
    mail(subject: "🚀 Новая заявка на дизайн-проект: #{@lead.name}")
  end
  def client_copy_email(lead)
    @lead = lead
    mail(to: @lead.email, subject: "Копия вашей заявки на дизайн-проект | ITDON")
  end
end