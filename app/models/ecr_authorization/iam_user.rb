# frozen_string_literal: true
module ECRAuthorization
  class IamUser
    include AwsAccess

    def initialize(name)
      @name = name
    end

    def create
      ec2.create_user({ user_name: @name })
    end

    def join(group)
      ec2.add_user_to_group(
        group_name: group.name,
        user_name: @name
      })
    end
  end
end
