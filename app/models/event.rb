class Event < ActiveRecord::Base
	has_one :reservation, dependent: :destroy
  
	attr_accessor :repeat, :frequency, :commit_button
    
    REPEATS = [
               "Does not repeat",
               "Reapeat Every 30 Minutes"
    ]

end
