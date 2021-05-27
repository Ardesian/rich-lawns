class ChargesController < ApplicationController
  def create
    @invoice = Invoice.find_by(token: params[:invoice])
    @stripe_card = current_user.default_payment_card

    charge = @stripe_card.charge(@invoice.cost_in_pennies)
    @invoice.update(stripe_charge: charge)

    if charge.success?
      @invoice.mark_paid
      SlackNotifier.notify("Invoice successfully paid. #{@invoice.token}", channel: '#rich-lawns', username: 'Cash-Bot', icon_emoji: ":money_with_wings:")

      redirect_to :account, notice: "Invoice paid successfully. Thank you!"
    else
      redirect_to :account, alert: "There was an error processing your card."
    end
  end
end
