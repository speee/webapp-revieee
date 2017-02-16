# frozen_string_literal: true
module SpotFleetRequest
  class RequestConfig
    IAM_FLEET_ROLE_ARN = Settings.spot_fleet.iam_fleet_role_arn
    SPOT_PRICE = Settings.spot_fleet.spot_price
    TARGET_CAPACITY = Settings.spot_fleet.target_capacity

    attr_reader :iam_fleet_role_arn, :spot_price, :target_capacity, :spot_instance

    def initialize(iam_role_arn: nil, spot_price: nil, capacity: nil, spot_instance: nil)
      @iam_fleet_role_arn = iam_role_arn || IAM_FLEET_ROLE_ARN
      @spot_price = spot_price || SPOT_PRICE
      @target_capacity = capacity || TARGET_CAPACITY
      @spot_instance = spot_instance
    end

    # TODO:
    # 異なるタイプのインスタンスをspecificationsに入れる際の設計
    def to_hash
      {
        spot_fleet_request_config: {
          iam_fleet_role: iam_fleet_role_arn,
          spot_price: spot_price.to_s,
          target_capacity: target_capacity.to_s,
          launch_specifications: [ spot_instance.to_hash ]
        }
      }
    end
  end
end
