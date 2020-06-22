Rails.configuration.stripe = {
  :publishable_key => 'pk_test_WW8hutIcbFeqp0IQSDX9iP8P00qjuV6ONa',
  :secret_key => 'sk_test_lXTSJnXALCuTtuQDYuR731eE00NxWqFAYn'
}
Stripe.api_key = Rails.configuration.stripe[:secret_key]