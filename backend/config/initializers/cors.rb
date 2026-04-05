frontend_host = ENV.fetch("FRONT_URL", "http://localhost")
frontend_port = ENV.fetch("FRONT_PORT", "3000")
frontend_origin = "#{frontend_host}:#{frontend_port}"

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins frontend_origin
    resource "*",
      headers: :any,
      methods: [ :get, :post, :put, :patch, :delete, :options, :head ]
  end
end
