require 'rails_helper'

RSpec.describe Lead, type: :model do
  describe 'Валидации' do
    let(:valid_answers) do
      {
        'step_1' => 'Квартира',
        'step_2' => ['Кухня', 'Спальня'],
        'step_3' => 60,
        'step_4' => 'Минимализм',
        'step_5' => '1 000 000 - 2 000 000 ₽'
      }
    end
    it 'успешно сохраняется с правильными данными' do
      lead = Lead.new(name: 'Иван', phone: '+79001234567', consent: true, answers: valid_answers)
      expect(lead).to be_valid
    end

    it 'не проходит валидацию без имени' do
      lead = Lead.new(phone: '+79001234567', consent: true, answers: valid_answers)
      expect(lead).not_to be_valid
      expect(lead.errors[:name]).to include("обязательно для заполнения")
    end

    it 'не проходит валидацию без телефона' do
      lead = Lead.new(name: 'Иван', consent: true, answers: valid_answers)
      expect(lead).not_to be_valid
    end

    it 'не проходит валидацию с пустым массивом зон (кастомная логика)' do
      lead = Lead.new(name: 'Иван', consent: true, phone: '+79001234567', answers: valid_answers.merge('step_2' => []))
      expect(lead).not_to be_valid
      expect(lead.errors[:base]).to include("Необходимо выбрать хотя бы одну зону для проектирования")
    end

    it 'не проходит валидацию если блок answers вообще пустой' do
      lead = Lead.new(name: 'Иван', consent: true, phone: '+79001234567', answers: nil)
      expect(lead).not_to be_valid
      expect(lead.errors[:answers]).to include("не могут быть пустыми")
    end
  end
end