class Rack::Attack
  api_base = ENV.fetch("RAILS_API", "/api/v1")
  Rack::Attack.blocklist("fail2ban pentesters") do |req|
    Rack::Attack::Fail2Ban.filter("pentesters-#{req.ip}", maxretry: 3, findtime: 10.minutes, bantime: 1.hour) do
      path = req.path.downcase
      path.include?(".env") ||
      path.include?(".git") ||
      path.start_with?("/config/") ||
      path.include?("master.key") ||
      path.include?("credentials")
    end
  end

  throttle("leads/ip", limit: 5, period: 1.minute) do |req|
    if req.path == "#{api_base}/leads" && req.post?
      req.ip
    end
  end

  throttle("chat/ip", limit: 5, period: 1.minute) do |req|
    if req.path == "#{api_base}/chat" && req.post?
      req.ip
    end
  end

  throttle("api/general", limit: 50, period: 1.minute) do |req|
    if req.path.start_with?("#{api_base}/")
      req.ip
    end
  end

  self.throttled_responder = lambda do |request|
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

  self.blocklisted_responder = lambda do |request|
    [ 403, { "Content-Type" => "application/json" }, [ { error: "Forbidden", message: "Access denied." }.to_json ] ]
  end
end
