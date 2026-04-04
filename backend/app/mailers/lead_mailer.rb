class LeadMailer < ApplicationMailer
  # ENV.fetch возьмет email из .env, а если его там нет — подставит admin@example.com
  default to: -> { ENV.fetch("MANAGER_EMAIL", "admin@example.com") }

  def new_lead_email(lead)
    @lead = lead
    mail(subject: "🚀 Новая заявка на дизайн-проект: #{@lead.name}")
  end
end