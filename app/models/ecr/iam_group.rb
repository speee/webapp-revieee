# frozen_string_literal: true
module Ecr
  class IamGroup
    include AwsAccessible
    extend AwsAccessible

    attr_reader :name

    class << self
      def create(name)
        iam.create_group({ group_name: name })
      end
    end

    def initialize(name)
      @name = name
    end
  end
end
