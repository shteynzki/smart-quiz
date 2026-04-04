Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # Разрешаем доступ с локалки И из домена в ENV (если он там будет)
    origins "localhost:3000", "127.0.0.1:3000", ENV.fetch("FRONTEND_URL", "")

    resource "*",
      headers: :any,
      methods: [ :get, :post, :put, :patch, :delete, :options, :head ]
  end
end
