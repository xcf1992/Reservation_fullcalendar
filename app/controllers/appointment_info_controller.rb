class AppointmentInfoController < ApplicationController
	skip_before_filter :require_login, only: [:index]
	
	def index
		@reservation = Reservation.new
	end
end
