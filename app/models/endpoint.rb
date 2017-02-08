class Endpoint < ApplicationRecord
  SUBDOMAIN_PREFIX = 'endpoint'.freeze

  belongs_to :task

  validates :ip, presence: true
  validates :port, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 65535 }
  validate :validate_ip_format

  def url
    "http://#{domain}/"
  end

  def domain
    "#{SUBDOMAIN_PREFIX}-#{id}.#{Settings.domain}"
  end

  private

  def validate_ip_format
    valid = IPAddr.new(ip).ipv4?
  rescue IPAddr::InvalidAddressError
    valid = false
  ensure
    errors.add(:ip, 'IPの形式が不正です') unless valid
  end
end
