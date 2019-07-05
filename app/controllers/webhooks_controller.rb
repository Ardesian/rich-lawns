class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def email
    Email.receive(request)
    head :no_content
  end
end
