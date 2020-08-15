class Admin::ServiceAddressesController < Admin::BaseController
  before_action :set_service_address

  def index
    @service_addresses = ServiceAddress.current.order("last_service DESC NULLS LAST, ID DESC")


    respond_to do |format|
      format.html
      format.json { render json: @service_addresses }
    end
  end

  def show
    @service_address = ServiceAddress.find_by!(token: params[:id])

    redirect_to [:new, :admin, :service_job, service_address_token: @service_address]
  end

  def new
    @service_address = ServiceAddress.new
    render :form
  end

  def create
    @service_address = ServiceAddress.new(service_address_params)

    if @service_address.save
      redirect_to [:admin, @service_address]
    else
      render :form
    end
  end

  def edit
    render :form
  end

  def update
    if @service_address.update(service_address_params)
      redirect_to [:admin, @service_address]
    else
      render :form
    end
  end

  def destroy
    if @service_address.update(removed_at: Time.current)
      redirect_to [:admin, :service_addresses]
    else
      redirect_to [:admin, @service_address], alert: "Something went wrong."
    end
  end

  private

  def service_address_params
    params.require(:service_address).permit(
      :name,
      :default_email,
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
