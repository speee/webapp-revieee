# frozen_string_literal: true
module ECRAuthorization
  class Repository
    include AwsAccessible

    def initialize(name)
      @name = name
    end

    def create
      response = ecr.create_repository({ repository_name: @name })
      @registry_id = response.repository.registry_id
      self
    end

    def allow_access(user_arn)
      ecr.set_repository_policy({
        registry_id: @registry_id,
        repository_name: @name,
        policy_text: policy_text(user_arn),
        force: false,
      })
    end

    private

    def policy_text(user_arn)
      {
        Version: '2008-10-17',
        Statement: [
          {
            Sid: 'AllowPushPull',
            Effect: 'Allow',
            Principal: { AWS: [ user_arn ] },
            Action: [
              'ecr:GetDownloadUrlForLayer',
              'ecr:BatchGetImage',
              'ecr:BatchCheckLayerAvailability',
              'ecr:PutImage',
              'ecr:InitiateLayerUpload',
              'ecr:UploadLayerPart',
              'ecr:CompleteLayerUpload'
            ]
          }
        ]
      }.to_json
    end
  end
end
