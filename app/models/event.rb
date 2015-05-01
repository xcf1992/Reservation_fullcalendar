class Event < ActiveRecord::Base
	has_one :reservation, dependent: :destroy
  
	attr_accessor :repeat, :stop_time, :replicate, :exception, :except_time_start, :except_time_end 
    
    REPEATS = [
               "Does not repeat",
               "Reapeat Every 30 Minutes",
               "Reapeat Every Hour"
    ]

    REPLICATES = [
               "No Replication",
               "Replicate On Weekdays",
               "Replicate On Weekends"
    ]

end
