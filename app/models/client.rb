class Client < ActiveRecord::Base
	validates :identification, uniqueness: true
end
