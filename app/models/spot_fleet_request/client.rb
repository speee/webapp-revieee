# frozen_string_literal: true
module SpotFleetRequest
  class Client
    attr_reader :ec2

    def initialize
      @ec2 = Aws::EC2::Client.new(region: Settings.aws.region)
    end

    def create
      spot_instance = SpotInstance.new
      request_config = RequestConfig.new(spot_instance: spot_instance)

      begin
        response = ec2.request_spot_fleet(request_config.to_hash)
        Rails.logger.info "spot fleet request is accepted! request_id: #{response.spot_fleet_request_id}"
      rescue => e
        Rails.logger.error "spot fleet request is denied! error message: #{e.message}"
      end
    end

    def cancel
    end
  end
end
