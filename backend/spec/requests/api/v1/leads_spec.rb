require 'swagger_helper'

RSpec.describe 'api/v1/leads', type: :request do
  path '/api/v1/leads' do
    post('Отправить заявку на дизайн-проект (Квиз)') do
      tags 'Заявки (Leads)'
      consumes 'application/json'
      produces 'application/json'

      # Описываем схему с корневым ключом lead
      parameter name: :payload, in: :body, schema: {
        type: :object,
        properties: {
          lead: {
            type: :object,
            properties: {
              name: { type: :string, example: 'Иван' },
              phone: { type: :string, example: '+7 (900) 000-00-00' },
              consent: { type: :boolean, example: true },
              email: { type: :string, example: 'example@mail.ru', nullable: true },
              comment: { type: :string, example: 'Нужен дизайн-проект для новой квартиры', nullable: true },
              page_url: { type: :string, example: 'https://site.ru/quiz' },
              utm_source: { type: :string, example: 'yandex', nullable: true },
              answers: {
                type: :object,
                properties: {
                  step_1: { type: :string, example: 'Квартира' },
                  step_2: { 
                    type: :array, 
                    items: { type: :string }, 
                    example: [ 'Кухня', 'Гостиная' ] 
                  },
                  step_3: { type: :integer, example: 85 },
                  step_4: { type: :string, example: 'Минимализм' },
                  step_5: { type: :string, example: '1 000 000 - 2 000 000 ₽' }
                }
              }
            },
            required: [ 'name', 'phone', 'consent', 'answers' ]
          }
        },
        required: [ 'lead' ]
      }

      response(201, 'Заявка успешно отправлена') do
        let(:payload) do
          { 
              lead: {
                name: 'Иван',
                phone: '+79001234567',
                consent: true,
                answers: {
                  'step_1' => 'Квартира',
                  'step_2' => ['Кухня'],
                  'step_3' => 85,
                  'step_4' => 'Минимализм',
                  'step_5' => '1 000 000 - 2 000 000 ₽'
                }
              }
          }
        end
        run_test!
      end

      response(422, 'Ошибка валидации (нет телефона)') do
        let(:payload) do
          { 
            lead: {
              name: 'Иван',
              consent: true,
              answers: {
                'step_1' => 'Квартира',
                'step_2' => ['Кухня'],
                'step_3' => 85,
                'step_4' => 'Минимализм',
                'step_5' => '1 000 000 - 2 000 000 ₽'
              }
            }
          }
        end
        run_test!
      end
    end
  end
end