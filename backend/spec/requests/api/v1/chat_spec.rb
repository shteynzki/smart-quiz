require 'swagger_helper'

RSpec.describe 'api/v1/chat', type: :request do
  api_base = ENV.fetch("RAILS_API", "/api/v1")

  path "#{api_base}/chat" do
    post('Отправить сообщение в AI-чат') do
      tags 'Chat'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :payload, in: :body, schema: {
        type: :object,
        properties: {
          messages: {
            type: :array,
            items: {
              type: :object,
              properties: {
                role: { type: :string, example: 'user' },
                content: { type: :string, example: 'Помоги выбрать стиль интерьера' }
              },
              required: [ 'role', 'content' ]
            }
          }
        },
        required: [ 'messages' ]
      }

      response(200, 'Ответ от AI получен') do
        let(:payload) do
          {
            messages: [
              { role: 'user', content: 'Помоги выбрать стиль интерьера' }
            ]
          }
        end

        let(:client) { instance_double(OpenAI::Client) }

        before do
          allow(OpenAI::Client).to receive(:new).and_return(client)
          allow(client).to receive(:chat).and_return(
            {
              "choices" => [
                { "message" => { "content" => 'Рекомендую начать с минимализма.' } }
              ]
            }
          )
        end

        run_test!
      end

      response(503, 'Нейросеть временно недоступна') do
        let(:payload) do
          {
            messages: [
              { role: 'user', content: 'Есть идеи по дизайну кухни?' }
            ]
          }
        end

        let(:client) { instance_double(OpenAI::Client) }

        before do
          allow(OpenAI::Client).to receive(:new).and_return(client)
          allow(client).to receive(:chat).and_return({})
        end

        run_test!
      end
    end
  end
end
