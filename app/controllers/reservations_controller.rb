class ReservationsController < ApplicationController
  skip_before_filter :require_login, only: [:create]

  before_action :set_reservation, only: [:show, :destroy]

	def index
    @reservations = Reservation.all
	end

	def create
  	@reservation = Reservation.new(reservation_params)
 
  	if @reservation.save
      @reservation.event.update_attribute(:occupied, true)
      redirect_to root_path,
      notice: 'Reserve Succeed.'
  	else 
  		render 'new'
  	end
  end

  def show
   	@reservation = Reservation.find(params[:id])
  end

  def new
    @reservation = Reservation.new
  end

  def destroy
    @reservation.event.update_attribute(:occupied, false)
    @reservation.destroy
    respond_to do |format|
      format.html { redirect_to reservations_url }
      format.json { head :no_content }
    end
  end

  private
    def set_reservation
      @reservation = Reservation.find(params[:id])
    end

    def reservation_params
    	params.require(:reservation).permit(:first_name, 
                                          :last_name, 
  			                                  :email, 
                                          :phone_number,
  			                                  :zip_code,
                                          :start_time,
                                          :end_time,
                                          :event_id)
    end
end