class UserController < ApplicationController
 	
 	def index
 		@users = User.all
 	end

 	def show
 		@user = user.find(params[:id])
 	end

 	
 	def new
 		@user = User.new
 	end

 	def create
 		@user = User.new(user_params)
 		if @user.save
 			redirect_to user_path(@user)
 		else #I don't have validation for this yet
 			render new_user_path
 		end
 	end

 	
 	def edit
 		@user = user.find(params[:id])
 	end

 	def update
 		@user = user.find(params[:id])
 		if @user.update(user_params)
 			redirect_to user_path(@user)
 		else
 			render edit_user_path
 		end
 	end

 	def destroy
 		@user = user.find(params[:id]).destroy
 		redirect_to new_user_path
 	end

 	private

 	def user_params
 		params.require(:user).permit(:name, :email, :password_digest)
 	end
 	

end
