class ReservationsController < ApplicationController
  skip_before_filter :require_login, only: [:create]

  before_action :set_reservation, only: [:show, :destroy]

	def index
    @reservations = Reservation.all
	end

  def edit
    @reservation = Reservation.find(params[:id])
  end

  def update
    @reservation = Reservation.find(params[:id])

    if @reservation.update(reservation_params)
      redirect_to clients_events_path
    end
  end

	def create
  	@reservation = Reservation.new(reservation_params)
 
  	if @reservation.save
      @reservation.event.update_attribute(:occupied, true)
      redirect_to root_path,
      notice: "Reserve Succeed! Please check your email for confirmation!"
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
      format.html { redirect_to '/events' }
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
                                          :showup,
                                          :comment,
                                          :tester)
    end
end