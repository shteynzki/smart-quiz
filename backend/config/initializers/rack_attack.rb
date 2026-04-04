class Rack::Attack
  ### 1. Настройка Fail2Ban (Черный список) ###
  # Блокируем IP на 1 час, если он 3 раза за 10 минут обращается к запрещенным путям
  # (попытки найти .env, wp-admin, конфиги и т.д.)
  Rack::Attack.blocklist("fail2ban pentesters") do |req|
    Rack::Attack::Fail2Ban.filter("pentesters-#{req.ip}", maxretry: 3, findtime: 10.minutes, bantime: 1.hour) do
      # Список паттернов, которые ищут боты-сканеры
      req.path.include?("wp-admin") ||
      req.path.include?(".env") ||
      req.path.include?("config") ||
      req.path.include?("phpmyadmin") ||
      req.path.include?(".git")
    end
  end

  ### 2. Лимиты для создания заявок (Leads) ###
  # Ограничение: 5 запросов в минуту на создание лида с одного IP
  throttle("leads/ip", limit: 5, period: 1.minute) do |req|
    if req.path == "/api/v1/leads" && req.post?
      req.ip
    end
  end

  ### 3. Лимиты для AI-Чата (Защита бюджета NVIDIA API) ###
  # Ограничение: 5 запросов в минуту на чат.
  # AI запросы тяжелые и дорогие, поэтому защищаем их отдельно.
  throttle("chat/ip", limit: 5, period: 1.minute) do |req|
    if req.path == "/api/v1/chat" && req.post?
      req.ip
    end
  end

  ### 4. Общий лимит для API (Защита от DDoS) ###
  # Не более 100 запросов в минуту на все API эндпоинты с одного IP
  throttle("api/general", limit: 100, period: 1.minute) do |req|
    if req.path.start_with?("/api/v1/")
      req.ip
    end
  end

  ### 5. Настройка ответа при блокировке ###
  self.throttled_responder = lambda do |request|
    # Определяем, какой именно лимит сработал, чтобы дать понятный ответ
    match_data = request.env["rack.attack.match_data"]
    now = match_data[:epoch_time]

    message = if match_data[:name] == "chat/ip"
                "Вы задаете вопросы слишком часто. Нейросеть отдыхает, попробуйте через минуту."
    elsif match_data[:name] == "leads/ip"
                "Слишком много заявок. Мы уже получили ваши данные, подождите немного."
    else
                "Слишком много запросов. Попробуйте позже."
    end

    [
      429,
      { "Content-Type" => "application/json" },
      [ { error: "Too Many Requests", message: message }.to_json ]
    ]
  end

  # Блокировка для черного списка (Fail2Ban)
  self.blocklisted_responder = lambda do |request|
    [ 403, { "Content-Type" => "application/json" }, [ { error: "Forbidden", message: "Access denied." }.to_json ] ]
  end
end
