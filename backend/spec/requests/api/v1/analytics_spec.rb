require 'swagger_helper'

RSpec.describe 'api/v1/analytics', type: :request do
  api_base = ENV.fetch("RAILS_API", "/api/v1")

  path "#{api_base}/analytics" do
    post('Сохранить аналитическое событие') do
      tags 'Analytics'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :payload, in: :body, schema: {
        type: :object,
        properties: {
          event_type: { type: :string, example: 'quiz_step_completed' },
          session_id: { type: :string, example: 'session-123' },
          payload: {
            type: :object,
            additionalProperties: true,
            example: {
              step: 3,
              answer: 'Минимализм'
            }
          }
        },
        required: [ 'event_type' ]
      }

      response(200, 'Событие сохранено') do
        let(:payload) do
          {
            event_type: 'quiz_step_completed',
            session_id: 'session-123',
            payload: {
              step: 3,
              answer: 'Минимализм'
            }
          }
        end

        run_test!
      end

      response(422, 'Ошибка валидации') do
        let(:payload) do
          {
            session_id: 'session-123'
          }
        end

        run_test!
      end
    end
  end
end
