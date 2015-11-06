module UserHelper
	def set_all_json(key)

		@user_id_api = "https://na.api.pvp.net/api/lol/na/v1.4/summoner/by-name/#{key}?api_key=#{ENV["API_KEY"]}"
		
		if valid_response_code(@user_id_api)
			puts "working api, no need to switch"
			summoner_id = HTTParty.get(@user_id_api)["#{key}"]["id"]
		else
			@user_id_api = "https://na.api.pvp.net/api/lol/na/v1.4/summoner/#{key}?api_key=#{ENV["API_KEY"]}"
			summoner_id = key
		end
		
		@recent_match_api = "https://na.api.pvp.net/api/lol/na/v1.3/game/by-summoner/#{summoner_id}/recent?api_key=#{ENV["API_KEY"]}"

		@divison_api = "https://na.api.pvp.net/api/lol/na/v2.5/league/by-summoner/#{summoner_id}?api_key=#{ENV["API_KEY"]}"

		return @array_of_json =[@user_id_api, @recent_match_api, @divison_api]

		#list of api's I choose not to use	
		#@ranked_matches = "https://na.api.pvp.net/api/lol/na/v2.2/matchlist/by-summoner/#{summoner_id}?api_key=#{ENV["API_KEY"]}"
		#@matches = "https://na.api.pvp.net/api/lol/na/v1.3/stats/by-summoner/#{summoner_id}/summary?season=SEASON2015&api_key=#{ENV["API_KEY"]}"
		#@champion_api = "https://global.api.pvp.net/api/lol/static-data/na/v1.2/champion/#{champion_id}?champData=all&api_key=#{ENV["API_KEY"]}"
	end

	def pull_ward_avg(json)
		arr_games = HTTParty.get(json)["games"]
		@ward_counts = []
		arr_games.each do |parse|
			@ward_counts.push(parse["stats"]["wardPlaced"])
		end
		ward_avg = (@ward_counts.reduce(:+))/@ward_counts.length
		return ward_avg
	end

	def valid_response_code(http)
		response = HTTParty.get(http)
		if response.code != 200
			puts "API is not returning 200 check again"
			return false
		end
			return true
	end



end
