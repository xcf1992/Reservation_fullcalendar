class UserMailer < ApplicationMailer
  default from: 'notification@leadtheway.com'
 
  def confirmation_email(reservation)
    @user = reservation
    @event = @user.event
    mail(to: @user.email, subject: 'Lead the Way Appointment Confirmation')
  end
end
