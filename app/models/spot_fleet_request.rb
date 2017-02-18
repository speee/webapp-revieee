# frozen_string_literal: true
module SpotFleetRequest
  def self.create
    spot_instance = SpotFleetRequest::SpotInstance.new
    request_config = SpotFleetRequest::RequestConfig.new(spot_instance: spot_instance)

    begin
      ec2_client = Aws::EC2::Client.new(region: Settings.aws.region)
      response = ec2_client.request_spot_fleet(request_config.to_hash)
      Rails.logger.info "spot fleet request is accepted! request_id: #{response.spot_fleet_request_id}"
    rescue => e
      Rails.logger.error "spot fleet request is denied! error message: #{e.message}"
    end
  end

  def describe
  end

  def cancel
  end
end
