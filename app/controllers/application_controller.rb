class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  SECRET = "yoursecretword"
  before_action :set_current_user

  def authentication
    decode_data = decode_user_data(request.headers["token"])
    user_data = decode_data[0]["user_data"] if decode_data.present?
    user = User.find_by(id: user_data) if user_data.present?
    if user
      return user
    else
      render json: { message: "Invalid credentials" }, status: :unauthorized
    end
  end

  def encode_user_data(payload)
    token = JWT.encode payload, SECRET, "HS256"
    return token
  end

  def decode_user_data(token)
    begin
      JWT.decode token, SECRET, true, { algorithm: "HS256" }
    rescue => e
      puts e
    end
  end

  private
  def current_user
    @current_user ||= begin
      token = request.headers[:token]
      if token
        user_data = decode_user_data(token)
        user_data_hash = user_data.first
        user_id = user_data_hash['user_data'] if user_data_hash.present?
        user = User.find_by(id: user_id) if user_id.present?
        return user
      else
        nil
      end
    rescue JWT::DecodeError => e
      puts "JWT Decode Error: #{e.message}"
      nil
    end
  end

  def set_current_user
    @current_user = current_user
  end
end
