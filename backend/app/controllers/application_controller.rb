class ApplicationController < ActionController::API
  include Pagy::Backend

  rescue_from StandardError, with: :handle_standard_error
  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found
  rescue_from ActionController::ParameterMissing, with: :handle_parameter_missing
  rescue_from ActionDispatch::Http::Parameters::ParseError, with: :handle_parse_error

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

  def handle_parameter_missing(e)
    render json: {
      error: "Bad Request",
      message: "В запросе отсутствует обязательный параметр: #{e.param}"
    }, status: :bad_request
  end

  def handle_parse_error(_e)
    render json: {
      error: "Bad Request",
      message: "Не удалось разобрать тело запроса. Проверьте JSON и Content-Type."
    }, status: :bad_request
  end
end
