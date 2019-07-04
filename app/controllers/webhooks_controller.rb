class WebhooksController < ApplicationController

  def email
    Email.receive(request)
    head :no_content
  end
end
