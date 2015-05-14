class ClientsController < ApplicationController
    skip_before_filter :require_login, only: [:create, :new]

	def new
      @client = Client.new
    end

    def create
      @client = Client.new(client_params)
      id = @client.identification
      @result = Test.find_by(:testId => id)

      if @result
        if @result.result == "CT NOT DETECTED; NG NOT DETECTED" 
          redirect_to @result, 
          notice: 'Your test result is ready to check right now'
        else
          redirect_to alert_test_path(id),
          notice: 'Your test result is ready to check right now'
        end
      end and return

      if @client.save
        UserMailer.registration_email(@client).deliver_now
        redirect_to :back, notice: 'Notification registration has been saved successfully. Please check your email for confirmation'
      else
        redirect_to :back, notice: 'Notification registration save failed. Please try again.'
      end
    end

	private
	  def client_params
	    params.require(:client).permit(:email, :phone, :identification, :confirmation)
	  end

end