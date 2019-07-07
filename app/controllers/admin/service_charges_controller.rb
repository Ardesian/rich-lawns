class Admin::ServiceChargesController < Admin::BaseController
  def index
    @service_charges = ServiceCharge.order(created_at: :desc)
  end

  def create
    @service_address = ServiceAddress.find_by!(token: params[:service_address_token])
    @client = @service_address.user

    @service_charge = @service_address.service_charges.new
    @service_charge.user = @client
    @service_charge.assign_attributes(service_charge_params)

    if @service_charge.save
      @service_address.serviced!
      redirect_to [:admin, :service_addresses], notice: "Sucessfully charged client."
    else
      redirect_to [:admin, @service_address], alert: "Charge failed"
    end
  end

  def service_charge_params
    params.require(:service_charge).permit(
      :charge,
      :notes
    )
  end
end
