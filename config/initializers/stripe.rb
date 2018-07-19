if Rails.env.production?
  Rails.configuration.stripe = {
    publishable_key: ENV['STRIPE_PUBLISHABLE_KEY'],
    secret_key: ENV['STRIPE_SECRET_KEY']
  }
else
  Rails.configuration.stripe = {
    publishable_key: 'pk_test_irhWvr5BBkFxq8XyGeNlsVmw',
    secret_key: 'sk_test_3qTMtbOiZHgbI0YGdV7IrJRK'
  }
end

Stripe.api_key = Rails.configuration.stripe[:secret_key]
