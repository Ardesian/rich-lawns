class InvoicesController < ApplicationController

  def show
    @invoice = Invoice.find_by(token: params[:id])
    @stripe_card = current_user.default_payment_card
  end
end
