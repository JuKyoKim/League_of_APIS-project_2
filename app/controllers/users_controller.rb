class UsersController < ApplicationController
	include UserHelper

 	def index
 		@users = User.all
 		@divs = DivStat.all
 	end

 	def show
 		@user = User.find(params[:id])
 		@div = DivStat.find(params[:id])
 		
	end

 	
 	def new
 		@user = User.new
 	end

 	def create
		@user = User.new(user_params)
  		if valid_response_code(@user.summoner_name)
  			@player = set_all_hash(@user.summoner_name.gsub(/\s+/, ""))
 			@avg = pull_hash_user_data(@player[1])
 			@div_avg = pull_division_avg(@player[2])
	
			@user.update({
						:ward_avg => @avg["ward_avg"],
						:gpm_avg => @avg["gpm_avg"],
						:cpm_avg => @avg["cpm_avg"],
						:kda_avg => @avg["kda_avg"],
						:kp_avg => @avg["killParticipation"]})
	
			@div = DivStat.new({
				   :division_name => @div_avg["division_name"],
						:ward_avg => @div_avg["ward_avg"],
					     :gpm_avg => @div_avg["gpm_avg"],
						 :cpm_avg => @div_avg["cpm_avg"],
						 :kda_avg => @div_avg["kda_avg"],
						  :kp_avg => @div_avg["killParticipation"]})
			@div.save
	
			if @user.save
  				redirect_to @user
  				flash[:notice] = 'invalid summoner name'
  			end
  		else
  			redirect_to root_path
  		end
 	end #end of create controller

 	def destroy
 		@user = User.find(params[:id]).destroy
 		redirect_to root_path
 	end

 	def terms
 		
 	end

 	private

 	def user_params
 		params.require(:user).permit(:summoner_name, :ward_avg, :gpm_avg, :cpm_avg, :kda_avg, :kp_avg)
 	end
 	

end


