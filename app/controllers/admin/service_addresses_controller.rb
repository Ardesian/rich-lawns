class Admin::ServiceAddressesController < Admin::BaseController
  def index
    @service_addresses = ServiceAddress.order(last_service: :desc, id: :desc)
  end

  def show
    @service_address = ServiceAddress.find_by!(token: params[:id])
    @client = @service_address.user
    @service_job = @service_address.service_jobs.new
  end
end
