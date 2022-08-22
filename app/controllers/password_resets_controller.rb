class PasswordResetsController < ApplicationController
  before_action :get_user, :valid_user, :check_expiration, only: %i(edit update)

  def new; end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_disget
      @user.send_password_reset_email
      flash[:info] = t ".email_send_success"
      redirect_to root_url
    else
      flash.now[:danger] = t ".email_not_found"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, t(".not_empty"))
      render :edit
    elsif @user.update(user_params)
      handle_login @user
    else
      flash[:danger] = t ".password_reset_fail"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def get_user
    @user = User.find_by(email: params[:email])

    return if @user.present?

    flash.now[:danger] = t ".user_not_found"
    redirect_to signup_url
  end

  def valid_user
    return if @user&.activated? && @user&.authenticated?(:reset, params[:id])

    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t ".password_expried"
    redirect_to new_password_reset_url
  end

  def handle_login user
    log_in user
    user.update_attribute(:reset_digest, nil)
    flash[:success] = t ".password_reset_success"
    redirect_to user
  end
end
