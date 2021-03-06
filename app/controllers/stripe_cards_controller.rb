class StripeCardsController < ApplicationController
  before_action :authenticate_user
  before_action :set_stripe_card

  def index
    @stripe_cards = current_user.stripe_cards.current.order(id: :desc)
  end

  def new
    @stripe_card = current_user.stripe_cards.current.new

    render :form
  end

  def create
    @stripe_card = current_user.stripe_cards.current.new(stripe_card_params)

    if @stripe_card.save
      redirect_to stripe_cards_path
    else
      render :form
    end
  end

  def edit
    render :form
  end

  def update
    if @stripe_card.update(stripe_card_params)
      redirect_to stripe_cards_path
    else
      render :form
    end
  end

  def destroy
    if @stripe_card.update(removed_at: Time.current)
      redirect_to stripe_cards_path
    else
      redirect_to stripe_cards_path, alert: "Something went wrong."
    end
  end

  private

  def stripe_card_params
    params.require(:stripe_card).permit(
      :name,
      :stripeToken,
      :default
    )
  end

  def set_stripe_card
    return unless params[:id].present?
    @stripe_card = current_user.stripe_cards.current.find_by!(token: params[:id])
  end

end
