class ClientsController < ApplicationController
    skip_before_filter :require_login, only: [:create, :new]

	def new
      @client = Client.new
    end

    def create
      @client = Client.new(client_params)

      if @client.save
        redirect_to :back, notice: 'Client Information has been saved successfully.'
      else
        redirect_to :back, notice: 'Client Information save failed. Please make sure input the correct identification number'
      end
    end

	private
	  def client_params
	    params.require(:client).permit(:email, :phone, :identification, :confirmation)
	  end

end