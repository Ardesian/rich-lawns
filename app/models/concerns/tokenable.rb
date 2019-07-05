module Tokenable
  extend ActiveSupport::Concern

  included do
    before_create :generate_token
  end

  def to_param
    token
  end

  protected

  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(4, false)
      break random_token unless self.class.exists?(token: random_token)
    end
  end
end
