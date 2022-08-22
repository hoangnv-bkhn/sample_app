class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if validate user
      user.activate
      log_in user
      flash[:success] = t ".user_success"
      redirect_to user
    else
      flash[:danger] = t ".user_unsuccess"
      redirect_to root_url
    end
  end

  private

  def validate user
    user && !user.activated? && user.authenticated?(:activation, params[:id])
  end
end
