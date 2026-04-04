require "rails_helper"

RSpec.describe LeadMailer, type: :mailer do
  describe 'new_lead_email' do
    # Используем create!, чтобы запись попала в БД и получила created_at
    let(:lead) do 
      Lead.create!(
        name: 'Хакатон', 
        phone: '+79001234567', 
        answers: { 'step_2' => ['Кухня'] } # Обязательно передаем зону
      ) 
    end
    let(:mail) { LeadMailer.new_lead_email(lead) }

    it 'формирует правильные заголовки' do
      expect(mail.subject).to eq("🚀 Новая заявка на дизайн-проект: Хакатон")
      expect(mail.to).to include(ENV.fetch("MANAGER_EMAIL", "admin@example.com"))
    end

    it 'содержит имя клиента в теле письма' do
      expect(mail.body.encoded).to match('Хакатон')
    end
  end
end