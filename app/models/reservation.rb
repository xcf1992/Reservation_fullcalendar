class Reservation < ActiveRecord::Base

	belongs_to :event
	
	validates :first_name, :presence => { :message => "Please enter your first name" }

	validates :last_name, :presence => { :message => "Please enter your last name" }

    validates :email, :presence => { :message => "Please enter your email address" }
	validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i,
                                message: "You have entered an invalid email address. Please try again."}

	validates :phone_number, :presence => { :message => "Please enter your phone number" }
	validates :phone_number, format: { with: /\d{10}/, 
	                                   message: "Phone number should be 10 digit number." }
    
    validates :zip_code, :presence => { :message => "Please enter your zip code" }
    validates :zip_code, format: { with: /\d{5}/, 
	                               message: "You have entered an invalid zip code. Please provide the first 5 digits of your zip code." }
end