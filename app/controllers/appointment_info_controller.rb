class AppointmentInfoController < ApplicationController
	skip_before_filter :require_login, only: [:index]
	
	def index
		@reservation = Reservation.new
		@client = Client.new
		@page = Page.find_by_id(1)
	end
end
