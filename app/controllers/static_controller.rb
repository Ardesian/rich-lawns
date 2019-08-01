class StaticController < ApplicationController

  def home
    redirect_to new_user_registration_path
  end

end
