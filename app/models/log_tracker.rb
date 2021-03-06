# == Schema Information
#
# Table name: log_trackers
#
#  id          :bigint           not null, primary key
#  user_id     :bigint
#  location_id :integer
#  url         :string
#  params      :string
#  http_method :string
#  ip_address  :string
#  user_agent  :string
#  ip_count    :integer
#  headers     :text
#  body        :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class LogTracker < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :location, optional: true

  after_initialize :set_additional_tracking
  after_create_commit :broadcast_creation

  scope :by_fuzzy_url, ->(url) { where("url ILIKE '%#{url}%'") }
  scope :by_ip, ->(ip) { where(ip_address: ip) }
  scope :not_me, -> { where.not(user_id: 1) }
  scope :not_log_tracker, -> { where.not("url ILIKE '%log_tracker%'") }

  def self.uniq_ips
    pluck(:ip_address).uniq
  end

  def params_json
    JSON.parse(params.gsub("=>", ":")) rescue params.to_s
  end

  def headers_json
    JSON.parse(headers.gsub("=>", ":")) rescue headers.to_s
  end

  def body_json
    JSON.parse(body.gsub("=>", ":")) rescue body.to_s
  end

  def short_location
    return nil unless location.present?
    [location.country_code.presence, location.region_code.presence, location.city.presence].join(", ")
  end

  private

  def set_additional_tracking
    set_ip_count if ip_count.nil?
    geolocate if location_id.nil?
  end

  def geolocate
    new_location_id = LogTracker.where(ip_address: self.ip_address).where.not(location_id: nil).pluck(:location_id).uniq.first
    self.location_id = new_location_id || Location.create(ip: self.ip_address).id
  end

  def set_ip_count
    now = self.created_at || DateTime.current
    self.ip_count = LogTracker.where.not(id: self.id).where("created_at < ?", now).where(ip_address: self.ip_address).count
  end

  def broadcast_creation
    # rendered_message = LogTrackersController.render partial: 'log_trackers/logger_row', locals: { logger: self }
    # ActionCable.server.broadcast "logger_channel", message: rendered_message
  end

end
