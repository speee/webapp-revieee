# frozen_string_literal: true
module ECRAuthorization
  class IamGroup
    include AwsAccess
    attr_reader :name

    def initialize(name)
      @name = name
    end

    def create
      ec2.create_group({ group_name: @name })
    end
  end
end
