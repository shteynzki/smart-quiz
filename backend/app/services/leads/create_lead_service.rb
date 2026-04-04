module Leads
  class CreateLeadService < ApplicationService
    include ActionView::Helpers::SanitizeHelper

    def initialize(params, remote_ip)
      @params = params
      @remote_ip = remote_ip
    end

    def call
      # Лог начала (пункт 12 ТЗ)
      Rails.logger.info "QUIZ_EVENT: submit | IP: #{@remote_ip}"

      # Очистка комментария
      sanitize_params!

      lead = Lead.new(@params)
      # Сохраняем IP в метаданные ответов для истории
      lead.answers ||= {}
      lead.answers["user_ip"] = @remote_ip

      if lead.save
        # Лог успеха (пункт 12 ТЗ)
        Rails.logger.info "QUIZ_EVENT: success | Lead ID: #{lead.id}"

        # Запуск задач
        NotifyManagerJob.perform_later(lead.id)

        OpenStruct.new(success?: true, lead: lead, errors: nil)
      else
        # Лог ошибки (пункт 12 ТЗ)
        Rails.logger.warn "QUIZ_EVENT: validation_error | Errors: #{lead.errors.full_messages}"

        OpenStruct.new(success?: false, lead: nil, errors: lead.errors.full_messages)
      end
    end

    private

  def sanitize_params!
  # Превращаем в обычный хеш для возможности модификации
  @params = @params.to_h.with_indifferent_access

  # Чистим все текстовые поля от HTML-тегов (защита от XSS)
  [ :name, :comment, :email, :phone ].each do |key|
    next unless @params[key].present?
    @params[key] = sanitize(@params[key].to_s, tags: [])
  end
end
  end
end
