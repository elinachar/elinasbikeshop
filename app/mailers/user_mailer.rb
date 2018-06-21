class UserMailer < ApplicationMailer
  default from: "elinachar@gmail.com"

  def contact_form(email, name, message)
  @message = message
    mail(from: email,
         to: 'elinachar@gmail.com',
         subject: "A new contact form message from #{name}")
  end
end
