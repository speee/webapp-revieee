# frozen_string_literal: true
module ECRAuthorization
  class IamGroup
    include AwsAccess
    def initialize(group_name)
      @group_name = group_name
    end
  end
end
