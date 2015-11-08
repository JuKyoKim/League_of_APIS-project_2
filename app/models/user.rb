class User < ActiveRecord::Base
	validates :summoner_name, presence: true, uniqueness: {case_sensitive: false}

end
