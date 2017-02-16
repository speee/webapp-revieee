# frozen_string_literal: true
class SpotFleetRequest
  # Spot Fleet Request Config
  IAM_FLEET_ROLE_ARN = Settings.spot_fleet.iam_fleet_role_arn
  SPOT_PRICE = Settings.spot_fleet.spot_price
  TARGET_CAPACITY = Settings.spot_fleet.target_capacity

  # Spot Fleet Launch Specifications
  AVAILABILITY_ZONE = Settings.spot_fleet.availability_zone
  GROUP_ID = Settings.spot_fleet.group_id
  IAM_INSTANCE_PROFILE = Settings.spot_fleet.iam_instance_profile
  IMAGE_ID = Settings.spot_fleet.image_id
  INSTANCE_TYPE = Settings.spot_fleet.instance_type
  KEY_NAME = Settings.spot_fleet.key_name
  SUBNET_ID = Settings.spot_fleet.subnet_id

  def create
  end

  def describe
  end

  def cancel
  end
end
