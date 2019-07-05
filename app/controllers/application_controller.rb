class ApplicationController < ActionController::Base
  before_action :see_current_user, :logit

  def flash_message
    flash.now[params[:flash_type].to_sym] = params[:message]
    render partial: 'layouts/flashes'
  end

  private

  def see_current_user
    Rails.logger.silence do
      if user_signed_in?
        current_user.see!
        request.env['exception_notifier.exception_data'] = { current_user: current_user }
      end
    end
  end

  def logit
    return CustomLogger.log_blip! if params[:checker]
    CustomLogger.log_request(request, current_user)
  end

  def unauthenticate_user
    if current_user.present?
      redirect_to new_user_session_path
    end
  end

  def authenticate_user
    unless current_user.present?
      session[:forwarding_url] = request.original_url if request.get?
      redirect_to new_user_session_path
    end
  end

  def authenticate_admin
    unless current_user.try(:admin?)
      session[:forwarding_url] = request.original_url if request.get?
      redirect_to new_user_session_path
    end
  end

  def after_sign_in_path_for(resource)
    flash.alert.clear if request.referrer.nil?
    account_path
  end
end
