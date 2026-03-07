class Rack::Attack
  throttle("req/ip", limit: 60, period: 1.minute) do |req|
    req.ip
  end

  throttle("login/ip", limit: 5, period: 20.seconds) do |req|
    req.path == "/auth/login" ? req.ip : nil
  end
end
