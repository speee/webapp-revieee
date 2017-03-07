module AwsAccess
  def ec2
    @ec2 ||= Aws::EC2::Client.new(region: Settings.aws.region)
  end

  def ecs
    @ecs ||= Aws::ECS::Client.new(region: Settings.aws.region)
  end

  def iam
    @iam ||= Aws::IAM::Client.new(region: Settings.aws.region)
  end

  def ecr
    @ecr ||= Aws::ECR::Client.new(region: Settings.aws.region)
  end
end
