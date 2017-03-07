# frozen_string_literal: true
module ECRAuthorization
  class IamGroup
    include AwsAccess
    attr_reader :name

    def initialize(name)
      @name = name
    end

    def create
      iam.create_group({ group_name: @name })
    end
  end
end
