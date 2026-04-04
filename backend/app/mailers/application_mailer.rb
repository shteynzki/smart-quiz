class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("SMTP_USER", "user@example.ru")
  layout "mailer"
end
