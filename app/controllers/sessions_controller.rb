class SessionsController < ApplicationController
	include SessionsHelper

	skip_before_action :authenticate, only: [:new,:create,:destroy]

	def new
	
	end
	
  def create
    user = User.find_by_email(params[:email])
    # If the user exists AND the password entered is correct.
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to user
    else
      redirect_to login_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to '/login'
  end
end