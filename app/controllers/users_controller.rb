class UsersController < ApplicationController
  before_action :redirect_if_authenticated, only: %i[create, new]

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_confirmation_email!
      redirect_to root_path, notice: 'Please check your for confirmation instructions. '
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    current_user.destroy
    reset_session
    redirect_to root_path, notice: 'Your account has been deleted. '
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.authenticate(params[:user][:current_password])
      if @user.update(update_user_params)
        @user.send_confirmation_email!
        redirect_to root_path, notice: 'Check your email for confirmation instructions. '
      else
        re  direct_to root_path, notice: 'Account updated. '
      end
    else
      render :edit, status: :unprocessable_entity
    end
  else
    flash.now[:error] = 'Incorrect password'
    render :edit, status: :unprocessable_entity
  end
end

def new
  @user = User.new
end

private

def user_params
  params.require(:user).permit(:email, :password, :password_confirmation)
end
end
