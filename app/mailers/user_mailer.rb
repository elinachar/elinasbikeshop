class UserMailer < ApplicationMailer
  default from: "info@elinasbikeshop.com"

  def contact_form(email, name, message)
    @message = message
    mail( from: email,
          to: 'elinachar@gmail.com',
          subject: "A new contact form message from #{name}")
  end

  def welcome(user)
    @appname = "Elina's Bike Shop"
    mail( from: "welcome@elinasbikeshop.com",
          to: user.email,
          subject: "Welcome to #{@appname}!")
   end

end
