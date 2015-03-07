class Event < ActiveRecord::Base
	has_one :reservation, dependent: :destroy
  
	attr_accessor :repeat, :frequency, :commit_button
    
    REPEATS = [
               "Does not repeat",
               "Reapeat Every 30 Minutes"
    ]

    def update_events (events, event)
      events.each do |e|
      	  begin 
        	st = e.start_time
        	et = e.end_time
        	e.attributes = event
        	if event_series.period.downcase == 'monthly' or event_series.period.downcase == 'yearly'
          	  nst = DateTime.parse("#{e.start_time.hour}:#{e.start_time.min}:#{e.start_time.sec}, #{e.start_time.day}-#{st.month}-#{st.year}")  
          	  net = DateTime.parse("#{e.end_time.hour}:#{e.end_time.min}:#{e.end_time.sec}, #{e.end_time.day}-#{et.month}-#{et.year}")
        	else
          	  nst = DateTime.parse("#{e.start_time.hour}:#{e.start_time.min}:#{e.start_time.sec}, #{st.day}-#{st.month}-#{st.year}")  
          	  net = DateTime.parse("#{e.end_time.hour}:#{e.end_time.min}:#{e.end_time.sec}, #{et.day}-#{et.month}-#{et.year}")
        	end
     	  rescue
        	nst = nil
        	net = nil
      	  end
      		
      	  if nst and net
        	e.start_time = nst
        	e.end_time = net
        	e.save
      	  end
      end
    
      event_series.attributes = event
      event_series.save
  	end

end
