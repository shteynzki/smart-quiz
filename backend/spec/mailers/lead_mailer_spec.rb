require "rails_helper"

RSpec.describe LeadMailer, type: :mailer do
  describe 'new_lead_email' do
    let(:lead) do
      Lead.create!(
        name: 'Хакатон',
        phone: '+79001234567',
        answers: {
          'step_1' => 'Квартира',
          'step_2' => [ 'Кухня' ],
          'step_3' => 85,
          'step_4' => 'Минимализм',
          'step_5' => '1 000 000 - 2 000 000 ₽'
        }
      )
    end
    let(:mail) { LeadMailer.new_lead_email(lead) }

    it 'формирует правильные заголовки' do
      expect(mail.subject).to eq("🚀 Новая заявка на дизайн-проект: Хакатон")
      expect(mail.to).to include(ENV.fetch("MANAGER_EMAIL", "manager@example.ru"))
    end

    it 'содержит имя клиента в теле письма' do
      expect(mail.body.encoded).to match('Хакатон')
    end
  end
end
