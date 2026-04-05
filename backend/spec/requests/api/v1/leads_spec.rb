require 'swagger_helper'

RSpec.describe 'api/v1/leads', type: :request do
  api_base = ENV.fetch("RAILS_API", "/api/v1")

  path "#{api_base}/leads" do
    post('Отправить заявку на дизайн-проект (Квиз)') do
      tags 'Заявки (Leads)'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :payload, in: :body, schema: {
        type: :object,
        properties: {
          lead: {
            type: :object,
            properties: {
              name: { type: :string, example: 'Иван' },
              phone: { type: :string, example: '+7 (900) 000-00-00' },
              consent: { type: :boolean, example: true },
              email: { type: :string, example: 'user@example.ru', nullable: true },
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
                  'step_2' => [ 'Кухня' ],
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
                'step_2' => [ 'Кухня' ],
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

    get('Получить список заявок') do
      tags 'Заявки (Leads)'
      produces 'application/json'
      parameter name: :secret, in: :query, type: :string, required: true,
                description: 'Секретный ключ для доступа к выгрузке лидов'
      parameter name: :page, in: :query, type: :integer, required: false,
                description: 'Номер страницы для пагинации'

      response(200, 'Список заявок получен') do
        let(:secret) { ENV.fetch("LEADS_EXPORT_SECRET", "supersecret") }
        let(:page) { 1 }

        before do
          Lead.create!(
            name: 'Иван',
            phone: '+79001234567',
            consent: true,
            answers: { step_1: 'Квартира' }
          )
        end

        run_test!
      end

      response(403, 'Доступ запрещён') do
        let(:secret) { 'wrong-secret' }

        run_test!
      end
    end
  end

  path "#{api_base}/leads/{id}/confirm_email" do
    post('Повторно отправить письмо клиенту') do
      tags 'Заявки (Leads)'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string, description: 'ID лида'

      response(200, 'Письмо успешно отправлено') do
        let(:id) do
          Lead.create!(
            name: 'Мария',
            phone: '+79005554433',
            email: 'maria@example.com',
            consent: true,
            answers: { step_1: 'Дом' }
          ).id
        end

        before do
          allow(LeadMailer).to receive_message_chain(:client_copy_email, :deliver_later)
        end

        run_test!
      end

      response(422, 'Лид не найден или email не указан') do
        let(:id) { '0' }

        run_test!
      end
    end
  end
end
