class UserMailer < ApplicationMailer
  default from: 'notification@leadtheway.com'
 
  # email sent out when client make appointments successfully
  def confirmation_email(reservation)
    @user = reservation
    @event = @user.event
    mail(to: @user.email, subject: 'Lead the Way Appointment Confirmation')
  end

  # email sent out when client make test result notification successfully
  def registration_email(client)
  	@id = client.identification
    mail(to: client.email, subject: 'Lead the Way Notification Registration')
  end

  # notification email sent to client when test result is ready
  def notificate_email(client)
    @testId = client.identification
    mail(to: client.email, subject: 'Early Test Result Notification')
  end
  
  # alert email sent to client if the test result is positive
  def alert_email(client)
    @testId = client.identification
    mail(to: client.email, subject: 'Early Test Result')
  end
end
