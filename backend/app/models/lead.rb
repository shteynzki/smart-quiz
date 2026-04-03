class Lead < ApplicationRecord

  validates :name, presence: { message: "обязательно для заполнения" }
  
  validates :phone, presence: { message: "обязателен для заполнения" }
end