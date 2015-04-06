class UserMailer < ApplicationMailer
  default from: 'DoNotReply@gmail.com'
 
  def reservation_email(reservation)
    @user = reservation
    @event = @user.event
    mail(to: @user.email, subject: 'Lead the Way Appointment Confirmation')
  end
end
