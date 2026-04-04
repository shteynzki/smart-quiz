class ApplicationController < ActionController::API
  include Pagy::Backend

  rescue_from StandardError, with: :handle_standard_error
  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found

  private

  def handle_standard_error(e)
    Rails.logger.error "[API_ERROR] #{e.class}: #{e.message}\n#{e.backtrace.first(10).join("\n")}"

    render json: {
      error: "Internal Server Error",
      message: "На сервере что-то пошло не так. Мы уже в курсе."
    }, status: :internal_server_error
  end

  def handle_not_found
    render json: { error: "Not Found", message: "Запись не найдена" }, status: :not_found
  end
end
