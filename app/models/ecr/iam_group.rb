# frozen_string_literal: true
module Ecr
  class IamGroup
    include AwsAccessible
    attr_reader :name

    def initialize(name)
      @name = name
    end

    def create
      iam.create_group({ group_name: @name })
    end
  end
end
