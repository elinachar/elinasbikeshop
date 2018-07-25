class PaymentsController < ApplicationController

  # POST /create
  # POST /create.json
  def create
    @product = Product.find(params[:product_id])
    @user = current_user
    token = params[:stripeToken]
    # byebug
    # Create the charge on Stripe's servers - this will charge the user's card
      begin
        charge = Stripe::Charge.create(
          amount: @product.price.to_int, # amount in cents
          currency: "usd",
          source: token,
          description: params[:stripeEmail],
          receipt_email: @user.email)

        if charge.paid
          Order.create(user: @user, product: @product, total: @product.price)
          @order = Order.where(user: @user).last
          UserMailer.order_submited(@order).deliver_now
        end
      rescue Stripe::CardError => e
        # The card has been declined
        body = e.json_body
        err = body[:error]
        byebug
        flash[:alert] = "Unfortunately, there was an error processing your payment: #{err[:message]}"
        redirect_to @product
      end

  end
end
