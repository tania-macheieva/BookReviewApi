class ApplicationController < ActionController::API
  before_action :authenticate_request

  attr_reader :current_user

  private
  
  def authenticate_request
    header = request.headers["Authorization"]
    token = header.split(" ").last if header
    decoded = JwtService.decode(token)
    @current_user = User.find(decoded[:user_id]) if decoded

    render json: { error: "Not authorized" }, status: :unauthorized unless @current_user
  rescue
    render json: { error: "Not authorized" }, status: :unauthorized
  end
end
