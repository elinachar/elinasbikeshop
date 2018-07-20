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

  def order_submited(order)
    @appname = "Elina's Bike Shop"
    @order = order
    @user = order.user
    mail(
    from: "auto-confirm@elinasbikeshop.com",
    to: @user.email,
    subject: "Your order at #{@appname}")
  end

end
