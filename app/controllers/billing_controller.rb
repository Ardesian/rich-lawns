class BillingController < ApplicationController
  before_action :authenticate_user
  before_action :set_stripe_card

  def index
    @stripe_cards = current_user.stripe_cards.order(id: :desc)
  end

  def new
    @stripe_card = current_user.stripe_cards.new

    render :form
  end

  def create
    @stripe_card = current_user.stripe_cards.current.new(stripe_card_params)

    if @stripe_card.save
      redirect_to account_path
    else
      render :form
    end
  end

  def edit
    render :form
  end

  def update
    if @stripe_card.update(stripe_card_params)
      redirect_to account_path
    else
      render :form
    end
  end

  def destroy
    if @stripe_card.update(removed_at: Time.current)
      redirect_to account_path
    else
      redirect_to account_path, alert: "Something went wrong."
    end
  end

  private

  def stripe_card_params
    params.require(:stripe_card).permit(:stripe_token)
  end

  def set_stripe_card
    return unless params[:id].present?
    @stripe_card = current_user.stripe_cards.find_by!(token: params[:id])
  end

end
