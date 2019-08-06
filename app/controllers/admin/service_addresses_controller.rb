class Admin::ServiceAddressesController < Admin::BaseController
  def index
    @service_addresses = ServiceAddress.order(last_service: :desc, id: :desc)
  end

  def show
    @service_address = ServiceAddress.find_by!(token: params[:id])
    @client = @service_address.user
    @service_job = @service_address.service_jobs.new
  end

  def new
    @service_address = ServiceAddress.new
    render :form
  end

  def create
    @service_address = ServiceAddress.new(service_address_params)

    if @service_address.save
      redirect_to [:admin, :service_addresses]
    else
      render :form
    end
  end

  def edit
    render :form
  end

  def update
    if @service_address.update(service_address_params)
      redirect_to [:admin, :service_addresses]
    else
      render :form
    end
  end

  def destroy
    if @service_address.update(removed_at: Time.current)
      redirect_to [:admin, :service_addresses]
    else
      redirect_to [:admin, :service_addresses], alert: "Something went wrong."
    end
  end

  private

  def service_address_params
    params.require(:service_address).permit(
      :name,
      :address,
      :city,
      :zip,
      :frequency
    )
  end

  def set_service_address
    return unless params[:id].present?
    @service_address = ServiceAddress.current.find_by!(token: params[:id])
  end
end
