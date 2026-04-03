class LeadMailer < ApplicationMailer

  default to: 'manager@example.com' 

  def new_lead_email(lead)
    @lead = lead
    mail(subject: "🚀 Новая заявка на дизайн-проект: #{@lead.name}")
  end
end