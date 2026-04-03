require 'swagger_helper'

RSpec.describe 'api/v1/leads', type: :request do
  path '/api/v1/leads' do
    post('Отправить заявку на дизайн-проект (Квиз)') do
      tags 'Заявки (Leads)'
      consumes 'application/json'
      produces 'application/json'

      # Описываем схему строго по пункту 10 из ТЗ!
      parameter name: :lead_params, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: 'Иван' },
          phone: { type: :string, example: '+7 (900) 000-00-00' },
          email: { type: :string, example: 'example@mail.ru', nullable: true },
          room_type: { type: :string, example: 'Квартира' },
          zones: { type: :array, items: { type: :string }, example: [ 'Кухня', 'Гостиная', 'Спальня' ] },
          area: { type: :integer, example: 85 },
          style: { type: :string, example: 'Минимализм' },
          budget: { type: :string, example: '1 000 000 - 2 000 000 ₽' },
          comment: { type: :string, example: 'Нужен дизайн-проект для новой квартиры', nullable: true },
          page_url: { type: :string, example: 'https://site.ru/quiz' },
          utm_source: { type: :string, example: 'yandex' }
        },
        required: [ 'name', 'phone' ]
      }

      response(201, 'Заявка успешно отправлена') do
        let(:lead_params) { { name: 'Иван', phone: '+79001234567', area: 85, zones: [ 'Кухня' ] } }
        run_test!
      end

      response(422, 'Ошибка валидации (нет телефона)') do
        let(:lead_params) { { name: 'Иван' } }
        run_test!
      end
    end
  end
end
