class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch('SMTP_USER', 'tkachyov.dmitriya@yandex.ru')
  layout "mailer"
end