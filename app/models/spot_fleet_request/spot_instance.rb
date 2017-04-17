# frozen_string_literal: true
module SpotFleetRequest
  class SpotInstance
    AVAILABILITY_ZONE = Settings.spot_fleet.availability_zone
    GROUP_ID = Settings.spot_fleet.group_id
    IAM_INSTANCE_PROFILE = Settings.spot_fleet.iam_instance_profile
    IMAGE_ID = Settings.spot_fleet.image_id
    INSTANCE_TYPE = Settings.spot_fleet.instance_type
    KEY_NAME = Settings.spot_fleet.key_name
    SUBNET_ID = Settings.spot_fleet.subnet_id
    CLUSTER_NAME = Settings.spot_fleet.cluster_name

    attr_reader :iam_instance_profile, :image_id, :instance_type
    attr_reader :key_name, :group_id, :subnet_id, :availability_zone

    def initialize(args: {})
      args = defaults.merge(args)

      @iam_instance_profile = args[:iam_instance_profile]
      @image_id = args[:image_id]
      @instance_type = args[:instance_type]
      @key_name = args[:key_name]
      @group_id = args[:group_id]
      @subnet_id = args[:subnet_id]
      @availability_zone = args[:availability_zone]
    end

    def to_hash
      {
        iam_instance_profile: { arn: iam_instance_profile },
        image_id: image_id,
        instance_type: instance_type,
        key_name: key_name,
        placement: { availability_zone: availability_zone },
        network_interfaces: [ network_interfaces ],
        user_data: user_data
      }
    end

    private

    def network_interfaces
      {
        device_index: 0,
        associate_public_ip_address: true,
        subnet_id: subnet_id,
        groups: [ group_id ],
        delete_on_termination: true,
      }
    end

    def user_data
      command = <<~COMMAND
        #!/bin/bash
        echo ECS_CLUSTER=#{CLUSTER_NAME} >> /etc/ecs/ecs.config
      COMMAND
      Base64.strict_encode64(command)
    end

    def defaults
      {
        availability_zone: AVAILABILITY_ZONE,
        iam_instance_profile: IAM_INSTANCE_PROFILE,
        group_id: GROUP_ID,
        image_id: IMAGE_ID,
        instance_type: INSTANCE_TYPE,
        key_name: KEY_NAME,
        subnet_id: SUBNET_ID
      }
    end
  end
end
