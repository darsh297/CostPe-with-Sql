class Api::V1::UsersController < ApplicationController
  protect_from_forgery with: :null_session
  skip_before_action :authenticate_user! # Disable CSRF protection

  def create
    user = User.find_by(email: params[:email])

    if user && user.valid_password?(params[:password])
      session[:user_id] = user.id
      render json: { status: 'success', message: 'Logged in successfully', data: user }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def destroy
    session.delete(:user_id)
    render json: { status: 'success', message: 'Logged out successfully' }, status: :ok
  end
end
