class Rack::Attack
  # Ограничение: 5 запросов в минуту на создание лида с одного IP
  throttle("leads/ip", limit: 5, period: 1.minute) do |req|
    if req.path == "/api/v1/leads" && req.post?
      req.ip
    end
  end

  # Ответ при блокировке
  self.throttled_responder = lambda do |request|
    [ 429,  { "Content-Type" => "application/json" }, [ { error: "Слишком много заявок. Попробуйте позже." }.to_json ] ]
  end
end
