class Test < ActiveRecord::Base
	validates :testId, uniqueness: true

    RESULTS = [
    	     " ",
             "Negative",
             "Positive",
             "Error",
             "Invalid"
    ]

	def self.search(search)
	  if search
	    where('testId LIKE ?', "%#{search}%")
	  else
	    all
	  end
	end

	# filter test results under different conditions
	def self.filter(ctP, ngP, resultP)
	  if ctP != " "
        if ngP != " "
		  if resultP != " "
		    where(:CT => ctP).where(:NG => ngP).where(:result => resultP)
		  else
            where(:CT => ctP).where(:NG => ngP)
		  end
		else
		  if resultP != " "
		    where(:CT => ctP).where(:result => resultP)
		  else
            where(:CT => ctP)
		  end	
		end
      else
        if ngP != " "
		  if resultP != " "
		    where(:NG => ngP).where(:result => resultP)
		  else
            where(:NG => ngP)
		  end
		else
		  if resultP != " "
		    where(:result => resultP)
		  else
            all
		  end	
		end
	  end
	end

	def self.to_csv(options = {})
	    CSV.generate do |csv|
	        csv << column_names
	        all.each do |test|
	          csv << test.attributes.values_at(*column_names)
	        end
	    end
	end
end
