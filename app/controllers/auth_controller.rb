class AuthController < ApplicationController
  skip_before_action :authenticate_request, only: [:login, :register]

  def register
    user = User.new(username: params[:username], email: params[:email], password: params[:password])
    if user.save
      token = JwtService.encode(user_id: user.id)
      render json: { token: token }
    else
      render json: { errors: user.errors }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      token = JwtService.encode(user_id: user.id)
      render json: { token: token }
    else
      render json: { error: "Invalid credentials" }, status: :unauthorized
    end
  end
end
