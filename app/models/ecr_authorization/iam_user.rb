# frozen_string_literal: true
module ECRAuthorization
  class IamUser
    include AwsAccess

    def initialize(user_name)
      @user_name = user_name
    end
  end
end
