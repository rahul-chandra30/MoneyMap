class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def razorpay
    webhook_body = request.body.read
    webhook_signature = request.headers['X-Razorpay-Signature']

    if valid_webhook_signature?(webhook_body, webhook_signature)
      process_webhook_event(JSON.parse(webhook_body))
      head :ok
    else
      head :bad_request
    end
  end

  private

  def valid_webhook_signature?(body, signature)
    Razorpay::Utility.verify_webhook_signature(
      body,
      signature,
      Rails.application.credentials.dig(:razorpay, :webhook_secret)
    )
  end

  def process_webhook_event(event)
    
  end
end