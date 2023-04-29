# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :redirect_if_authenticated, only: %i[create new]

  def create
    if authenticate_user
      login @user
      redirect_to root_path, notice: 'Signed in. '
    else
      flash.now[:alert] = 'Incorrect email or password. '
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to root_path, notice: 'Signed out. '
  end

  def new
  end

  private

  def authenticate_user
    @user = User.find_by(email: params[:user][:email].downcase)
    return false unless @user

    if @user.unconfirmed?
      redirect_to new_confirmation_path, alert: 'Please confirm your email address to continue. '
      return false
    end

    @user.authenticate(params[:user][:password])
  end
end
