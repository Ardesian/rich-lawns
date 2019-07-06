Rails.configuration.stripe = {
  publishable_key: ENV['RICH_STRIPE_PUB'],
  secret_key:      ENV['RICH_STRIPE_KEY']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
