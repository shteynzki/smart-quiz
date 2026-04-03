class Lead < ApplicationRecord
  validates :name, presence: { message: "обязательно для заполнения" }
  
  validates :phone, 
            presence: { message: "обязателен для заполнения" },
            format: { 
              with: /\A\+?[\d\s\-\(\)]+\z/, 
              message: "имеет неверный формат (допускаются только цифры, +, пробелы, скобки и дефисы)" 
            },
            length: { minimum: 7, maximum: 20, message: "слишком короткий или длинный" }
            
  validates :email, 
            format: { with: URI::MailTo::EMAIL_REGEXP, message: "имеет неверный формат" }, 
            allow_blank: true
end