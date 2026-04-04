require 'rails_helper'

RSpec.describe Lead, type: :model do
  describe 'Валидации' do
    it 'успешно сохраняется с правильными данными' do
      lead = Lead.new(name: 'Иван', phone: '+79001234567', answers: { 'step_2' => ['Кухня', 'Спальня'] })
      expect(lead).to be_valid
    end

    it 'не проходит валидацию без имени' do
      lead = Lead.new(phone: '+79001234567', answers: { 'step_2' => ['Кухня'] })
      expect(lead).not_to be_valid
      expect(lead.errors[:name]).to include("обязательно для заполнения")
    end

    it 'не проходит валидацию без телефона' do
      lead = Lead.new(name: 'Иван', answers: { 'step_2' => ['Кухня'] })
      expect(lead).not_to be_valid
    end

    it 'не проходит валидацию с пустым массивом зон (кастомная логика)' do
      lead = Lead.new(name: 'Иван', phone: '+79001234567', answers: { 'step_2' => [] })
      expect(lead).not_to be_valid
      expect(lead.errors[:base]).to include("Необходимо выбрать хотя бы одну зону для проектирования")
    end

    it 'не проходит валидацию если блок answers вообще пустой' do
      lead = Lead.new(name: 'Иван', phone: '+79001234567', answers: nil)
      expect(lead).not_to be_valid
      expect(lead.errors[:base]).to include("Необходимо выбрать хотя бы одну зону для проектирования")
    end
  end
end