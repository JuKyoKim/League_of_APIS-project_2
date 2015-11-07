module UserHelper
	def avg(num_array)
		return num_array.reduce(:+)/num_array.length
	end

	def set_all_json(key)
		@user_id_api = "https://na.api.pvp.net/api/lol/na/v1.4/summoner/by-name/#{key}?api_key=#{ENV["API_KEY"]}"
		
		if valid_response_code(@user_id_api)
			puts "working api, no need to switch"
			@summoner_id = HTTParty.get(@user_id_api)["#{key}"]["id"]
			sleep 2
		else
			puts "changing api for id"
			@user_id_api = "https://na.api.pvp.net/api/lol/na/v1.4/summoner/#{key}?api_key=#{ENV["API_KEY"]}"
			@summoner_id = key
		end
		
		@recent_match_api = "https://na.api.pvp.net/api/lol/na/v1.3/game/by-summoner/#{@summoner_id}/recent?api_key=#{ENV["API_KEY"]}"

		@divison_api = "https://na.api.pvp.net/api/lol/na/v2.5/league/by-summoner/#{@summoner_id}?api_key=#{ENV["API_KEY"]}"
		
		return [@user_id_api, @recent_match_api, @divison_api]
	end

	def pull_ward_avg(json)
		arr_games = HTTParty.get(json)["games"]
		sleep 2
		ward_counts = []
		arr_games.each do |parse|
			if parse["stats"]["wardPlaced"] == nil
				ward_counts.push(0)
			else
				ward_counts.push(parse["stats"]["wardPlaced"])
			end
		end
		# sum = ward_counts.reduce(:+)
		# ward_avg = sum/ward_counts.length

		return avg(ward_counts)
	end

	def valid_response_code(http)
		response = HTTParty.get(http)
		if response.code != 200
			puts "API is not returning 200 check again"
			return false
		end
			return true
		sleep 2
	end

	def pull_division_avg(json)
		#pass the @divison_api first and then ONLY the @summoner_id

		pulled_json = json
		parsed_json = HTTParty.get(pulled_json)
		sleep 2
		summoner_id = parsed_json.first[0]
		@division_name = parsed_json[summoner_id][0]["tier"]
		temp_arr = []

		7.times do |x|
			ind_sum = parsed_json[summoner_id][0]["entries"][x]
			json_set = set_all_json(ind_sum["playerOrTeamId"].to_i) #grabs the api calls for everyone in division
			avg_ward = pull_ward_avg(json_set[1]) #grabs the ward avg for each player
			temp_arr.push(avg_ward)
		end
		return avg(temp_arr)
		
	end

end
