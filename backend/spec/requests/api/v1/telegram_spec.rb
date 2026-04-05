require 'swagger_helper'

RSpec.describe 'api/v1/telegram', type: :request do
  api_base = ENV.fetch("RAILS_API", "/api/v1")

  path "#{api_base}/telegram/webhook" do
    post('Получить webhook от Telegram') do
      tags 'Telegram'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :payload, in: :body, schema: {
        type: :object,
        properties: {
          message: {
            type: :object,
            properties: {
              text: { type: :string, example: '/start 123' },
              chat: {
                type: :object,
                properties: {
                  id: { type: :integer, example: 123_456_789 }
                }
              }
            }
          }
        }
      }

      response(200, 'Webhook обработан') do
        let(:lead) do
          Lead.create!(
            name: 'Анна',
            phone: '+79001112233',
            email: 'anna@example.com',
            consent: true,
            comment: 'Хочу обсудить дизайн кухни',
            answers: {
              room_type: 'Квартира',
              area: 72,
              zones: [ 'Кухня', 'Гостиная' ],
              style: 'Скандинавский',
              budget: '1 000 000 - 2 000 000 ₽'
            }
          )
        end

        let(:payload) do
          {
            message: {
              text: "/start #{lead.id}",
              chat: { id: 123_456_789 }
            }
          }
        end

        before do
          allow_any_instance_of(Api::V1::TelegramController).to receive(:send_message).and_return(true)
        end

        run_test!
      end
    end
  end
end
