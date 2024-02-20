class UsersController < ApplicationController
  def signup
    user=User.new(user_params)
    if user.save
      UserMailer.confirm_email(user).deliver_now
      render json: { message: 'User created successfully. Confirmation email sent.' }, status: :created
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: params[:user][:email])
    if user.nil?
      render json: { message: "Invalid credentials" }
      return
    end

    if !user.confirmed
      render json: { message: "User is not verified" }
      return
    end
    if user && user.password_digest == (params[:user][:password_digest])
      token = encode_user_data({ user_data: user.id })
      render json: { token: token }
    else
      render json: { message: "Invalid credentials" }
    end
  end

  def confirm_email
    user = User.find_by(confirmation_token: params[:token])
    if user
      user.update(confirmed: true)
      render json: { message: 'Your email address has been confirmed!' }, status: :ok
    else
      render json: { error: 'Invalid confirmation token.' }, status: :unprocessable_entity
    end
  end

  def fotgot_password
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password_digest)
  end
end
