class LeadMailer < ApplicationMailer
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
