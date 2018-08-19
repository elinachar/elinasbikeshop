class PaymentsController < ApplicationController

  # POST /create
  # POST /create.json
  def create
    @product = Product.find(params[:product_id])
    if params[:user]
      @user = current_user
    else
      @user = User.new(first_name: "Guest", last_name: "User", email: params[:stripeEmail], password: "000000")
      if !@user.save
        if  @user.errors.full_messages == ["Email has already been taken"]
          error = " The email in your Stripe account already exists in Elina's Bike Shop. Please either login in Elina's Bike Shop to continue the purchase or use another Stripe account."
        else
          error = ""
        end
        flash[:alert] = "Unfortunately, there was an error processing your payment." + error
        redirect_to @product and return
      end
    end
    token = params[:stripeToken]
    # Create the charge on Stripe's servers - this will charge the user's card
      begin
        charge = Stripe::Charge.create(
          amount: @product.price.to_int*100, # amount in cents
          currency: "usd",
          source: token,
          description: params[:stripeEmail],
          receipt_email: @user.email)

        if charge.paid
          Order.create(user: @user, product: @product, total: @product.price)
          @order = Order.where(user: @user).last
          UserMailer.order_created(@order).deliver_now
        end
      rescue Stripe::CardError => e
        # The card has been declined
        body = e.json_body
        err = body[:error]
        flash[:alert] = "Unfortunately, there was an error processing your payment: #{err[:message]}"
        redirect_to @product
      end

  end
end
