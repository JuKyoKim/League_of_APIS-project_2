module ApplicationHelper
	#this is for clearing the console whenever i need it
	def shell_exec(txt)
    @txt = txt
    system @txt
    	if $?.exitstatus > 0
    	    puts "command was either not found, or cannot be run"
    	end
	end

end
