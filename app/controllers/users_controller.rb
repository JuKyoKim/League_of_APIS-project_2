class UsersController < ApplicationController
	include UserHelper

 	def index
 		@users = User.all
 		@player = set_all_hash("siranimay")
 		@avg = pull_hash_user_data(@player[1])
 		@div_avg = pull_division_avg(@player[2])
 	end

 	def show
 		@user = User.find(params[:id])
	end

 	
 	def new
 		@user = User.new
 	end

 	def create
    user = User.new(user_params)
    	if user.save
    		session[:user_id] = user.id
    		redirect_to user_path(user)
    	else
    		redirect_to new_user_path
    	end
  	end

 	
 	def edit
 		@user = User.find(params[:id])
 	end

 	def update
 		@user = User.find(params[:id])
 		if @user.update(user_params)
 			redirect_to user_path(@user)
 		else
 			render edit_user_path
 		end
 	end

 	def destroy
 		@user = User.find(params[:id]).destroy
 		redirect_to new_user_path
 	end

 	private

 	def user_params
 		params.require(:user).permit(:name, :email, :password, :password_confirmation)
 	end
 	

end
