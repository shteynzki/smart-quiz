require 'swagger_helper'

RSpec.describe 'api/v1/leads', type: :request do
  path '/api/v1/leads' do
    post('Создать новую заявку из квиза') do
      tags 'Заявки (Leads)'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :lead_params, in: :body, schema: {
        type: :object,
        properties: {
          lead: {
            type: :object,
            properties: {
              name: { type: :string, example: 'Алена' },
              phone: { type: :string, example: '+79991234567' },
              email: { type: :string, example: 'alena@example.com', nullable: true },
              answers: { 
                type: :object, 
                example: { "step_1": "Квартира", "step_2": "50 кв.м", "step_3": "Лофт" } 
              }
            },
            required: [ 'name', 'phone' ]
          }
        }
      }

      response(201, 'Заявка успешно создана') do
        let(:lead_params) { { lead: { name: 'Алена', phone: '+79991234567' } } }
        run_test!
      end

      response(422, 'Ошибка валидации (например, нет телефона)') do
        let(:lead_params) { { lead: { name: 'Алена' } } }
        run_test!
      end
    end
  end
end