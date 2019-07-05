class AccountController < ApplicationController
  before_action :authenticate_user

  def show
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
