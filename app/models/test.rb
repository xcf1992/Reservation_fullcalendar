class Test < ActiveRecord::Base
	validates :testId, uniqueness: true

	def self.search(search)
	  if search
	    where('testId LIKE ?', "%#{search}%")
	  else
	    all
	  end
	end

	def self.filter(ctP, ngP, resultP)
	  if ctP
        if ngP
		  if resultP
		    where(:CT => "Positive").where(:NG => "Positive").where(:result => "Positive")
		  else
            where(:CT => "Positive").where(:NG => "Positive")
		  end
		else
		  if resultP
		    where(:CT => "Positive").where(:result => "Positive")
		  else
            where(:CT => "Positive")
		  end	
		end
      else
        if ngP
		  if resultP
		    where(:NG => "Positive").where(:result => "Positive")
		  else
            where(:NG => "Positive")
		  end
		else
		  if resultP
		    where(:result => "Positive")
		  else
            all
		  end	
		end
	  end
	end
end
