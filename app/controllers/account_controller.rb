class AccountController < ApplicationController
  before_action :authenticate_user

  def show
    @service_addresses = current_user.service_addresses.current.order(:id)
    @stripe_card = current_user.default_payment_card
  end

  def edit
    # @user = current_user
  end

  def update
    # @user = current_user
    #
    # if @user.update(user_params)
    # else
    # end
  end

  private

  def user_params
    # params.require(:user).permit(
    #   :fname
    # )
  end

end
