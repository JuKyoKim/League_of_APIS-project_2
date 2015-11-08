class UsersController < ApplicationController
	include UserHelper

 	def index
 		@users = User.all
 	end

 	def show
 		@user = User.find(params[:id])
 		@player = set_all_hash(@user.summoner_name.gsub(/\s+/, ""))
 		@avg = pull_hash_user_data(@player[1])
 		@div_avg = pull_division_avg(@player[2])
	end

 	
 	def new
 		@user = User.new
 	end

 	def create
  		@user = User.new(user_params)
  		puts @user

  		if @user.save
  			redirect_to @user
  		end
  	end

 	private

 	def user_params
 		params.require(:user).permit(:summoner_name)
 	end
 	

end
