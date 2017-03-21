# frozen_string_literal: true
module Ecr
  class IamUser
    include AwsAccessible
    extend AwsAccessible

    class << self
      def create(name)
        response = iam.create_user({ user_name: name })
        new(name, arn: response.user.arn)
      end
    end

    def initialize(name, arn: nil)
      @name = name
      @arn = arn
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
