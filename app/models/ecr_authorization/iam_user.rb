# frozen_string_literal: true
module ECRAuthorization
  class IamUser
    include AwsAccess

    def initialize(name)
      @name = name
    end

    def create
      iam.create_user({ user_name: @name })
    end

    def create_access_key
      iam.create_access_key({ user_name: @name })
    end

    def join(group)
      iam.add_user_to_group({
        group_name: group.name,
        user_name: @name
      })
    end
  end
end
