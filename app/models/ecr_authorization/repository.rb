# frozen_string_literal: true
module ECRAuthorization
  class Repository
    include AwsAccess

    def initialize(name)
      @name = name
    end

    def create
      response = ecs.create_repository({ repository_name: @name })
      @registry_id = response.repository.registry_id
      self
    end
  end
end
