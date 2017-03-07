# frozen_string_literal: true
module ECRAuthorization
  class Repository
    include AwsAccess

    def initialize(name)
      @name = name
    end
  end
end
