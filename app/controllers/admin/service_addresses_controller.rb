class Admin::ServiceAddressesController < Admin::BaseController
  def index
    @service_addresses = ServiceAddress.order(last_service: :desc, id: :desc)
  end

  def show
    @service_address = ServiceAddress.find_by!(token: params[:id])
    @client = @service_address.user
    @stripe_card = @client.default_payment_card
    @service_charge = @stripe_card.try(:service_charges).try(:new)
  end
end
