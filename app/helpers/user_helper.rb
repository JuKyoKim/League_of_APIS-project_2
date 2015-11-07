module UserHelper

	# def valid_response_code(http)
	# 	response = HTTParty.get(http)
	# 	if response.code != 200
	# 		puts "request is not returning 200 check again"
	# 		return false
	# 	end
	# 		return true
	# end

	def avg(num_array)
		return num_array.reduce(:+)/num_array.length
	end

	def set_all_hash(key)
		
		if key.class == Fixnum
			puts "changing api for id"
			user_id_hash = HTTParty.get("https://na.api.pvp.net/api/lol/na/v1.4/summoner/#{key}?api_key=#{ENV["API_KEY"]}")
			summoner_id = key
		else
			puts "working api, no need to switch"
			user_id_hash = HTTParty.get("https://na.api.pvp.net/api/lol/na/v1.4/summoner/by-name/#{key}?api_key=#{ENV["API_KEY"]}")
			summoner_id = user_id_hash["#{key}"]["id"]
		end
		recent_match_hash = HTTParty.get("https://na.api.pvp.net/api/lol/na/v1.3/game/by-summoner/#{summoner_id}/recent?api_key=#{ENV["API_KEY"]}")
		divison_hash = HTTParty.get("https://na.api.pvp.net/api/lol/na/v2.5/league/by-summoner/#{summoner_id}?api_key=#{ENV["API_KEY"]}")
		sleep 3

		puts "https://na.api.pvp.net/api/lol/na/v1.3/game/by-summoner/#{summoner_id}/recent?api_key=#{ENV["API_KEY"]}"
		return [user_id_hash, recent_match_hash, divison_hash]
	end

	def pull_hash_user_data(hash)
		ward_counts = []
		gpm = []
		cpm = []
		kda_per_set = []
		kp_per_set = []
		arr_games = hash["games"]
		arr_games.each do |parse|
			if parse["stats"]["wardPlaced"] == nil
				ward_counts.push(0)
			else
				ward_counts.push(parse["stats"]["wardPlaced"])
			end

			match_key = parse["gameId"]
			current_player_id = parse["championId"]
			match_hash = HTTParty.get("https://na.api.pvp.net/api/lol/na/v2.2/match/#{match_key}?api_key=7a09121a-98eb-4998-8a13-2a387c052455")
			sleep 1
			if match_hash["matchType"] == "CUSTOM_GAME"
				next
			else

				kill_total_match = 0
				player_kills = 0
				match_hash["participants"].each do |x|
					if x["championId"] == current_player_id
						player_gpm = x["timeline"]["goldPerMinDeltas"]["tenToTwenty"]
	
						player_cpm = x["timeline"]["creepsPerMinDeltas"]["tenToTwenty"]
						
						player_kills = x["stats"]["kills"] + x["stats"]["assists"]
						
						deaths = x["stats"]["deaths"]
	
	
						if deaths == 0
							kda = player_kills
						else
							kda = player_kills/deaths
						end
						
						gpm.push(player_gpm)
						cpm.push(player_cpm)
						kda_per_set.push(kda)
						
						
	
						puts "gpm is: "+player_gpm.to_s
						puts "cpm is: "+player_cpm.to_s
						puts "kda is: "+kda.to_s
						puts "player_kills: "+player_kills.to_s
	
					end #end of current player conditional
	
					kill_total_match = kill_total_match +  x["stats"]["kills"]

				end #end of each participant
				puts "team kills: "+kill_total_match.to_s
				puts "player kills: "+player_kills.to_s
				kp_in_match = ((player_kills.to_f/kill_total_match.to_f)*100)
				puts "killParticipation: "+kp_in_match.to_s
		
				kp_per_set.push(kp_in_match)
				puts
				puts
				puts
			end #end of match

		end
		
		hash_of_data = {
			"ward_avg" => avg(ward_counts),
			"gpm_avg" => avg(gpm).round,
			"cpm_avg" => avg(cpm).round,
			"kda_avg" => avg(kda_per_set),
			'killParticipation' => avg(kp_per_set).round
		}

		puts "end of method"
		return hash_of_data
	end

	def pull_division_avg(hash)
		#pass the divison_api first and then ONLY the @summoner_id
		summoner_id = hash.first[0]
		@division_name = hash[summoner_id][0]["tier"]
		temp_arr = []
		3.times do |x|
			ind_sum = hash[summoner_id][0]["entries"][x]["playerOrTeamId"]
			new_hash_set = set_all_hash(ind_sum.to_i)
			avg = pull_hash_user_data(new_hash_set[1])
			temp_arr.push(avg)
		end
		
		return temp_arr
		
	end

end
