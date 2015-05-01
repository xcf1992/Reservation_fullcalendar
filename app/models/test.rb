class Test < ActiveRecord::Base
	validates :testId, uniqueness: true
end
