# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def contact_form
    UserMailer.contact_form("john@example.com", "John", "Hello World!")
  end

  def welcome
    UserMailer.welcome(User.first)
  end

  def order_submited
    UserMailer.order_submited(Order.first)
  end
end
