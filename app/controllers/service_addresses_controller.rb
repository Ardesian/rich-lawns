class ServiceAddressesController < ApplicationController
  before_action :authenticate_user
  before_action :set_service_address

  def new
    @service_address = current_user.service_addresses.current.new
    render :form
  end

  def create
    @service_address = current_user.service_addresses.current.new(service_address_params)

    if @service_address.save
      redirect_to :account
    else
      render :form
    end
  end

  def edit
    render :form
  end

  def update
    if @service_address.update(service_address_params)
      redirect_to :account
    else
      render :form
    end
  end

  def destroy
    if @service_address.update(removed_at: Time.current)
      redirect_to :account
    else
      redirect_to :account, alert: "Something went wrong."
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
    @service_address = current_user.service_addresses.current.find_by!(token: params[:id])
  end
end
