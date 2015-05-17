class Test < ActiveRecord::Base
	validates :testId, uniqueness: true

	def self.search(search)
	  if search
	    where('testId LIKE ?', "%#{search}%")
	  else
	    scoped
	  end
	end
end
