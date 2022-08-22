class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      handle_authenticated user
    else
      flash.now[:danger] = t ".login_fail"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def handle_authenticated user
    if user.activated?
      handle_login user
    else
      flash[:warning] = t ".account_not_activated"
      redirect_to root_url
    end
  end
end
