class Endpoint < ApplicationRecord
  IP_REGEXP = /\A(([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5]).){3}([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\z/.freeze
  SUBDOMAIN_PREFIX = 'endpoint'.freeze

  belongs_to :task

  validates :ip, presence: true, format: { with: IP_REGEXP }
  validates :port, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 65535 }

  def url
    "http://#{domain}/"
  end

  def domain
    "#{SUBDOMAIN_PREFIX}-#{id}.#{Settings.domain}"
  end
end
