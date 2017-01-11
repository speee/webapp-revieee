class Task
  include ActiveModel::Model

  attr_accessor :arn

  validates :task_arn, presence: true

  def stop
    ecs.stop_task(
      cluster: Settings.aws.ecs.cluster_name,
      task: arn,
    )
  end

  def private_ip
    container_instance_arn = task.dig(:container_instance_arn)
    instance_id = ecs.describe_container_instances(
      cluster: Settings.aws.ecs.cluster_name,
      container_instances: [container_instance_arn]
    ).dig(:container_instances, 0, :ec2_instance_id)
    ec2.describe_instances(instance_ids: [instance_id]).dig(:reservations, 0, :instances, 0, :private_ip_address)
  end

  def port
    task.dig(:containers).map(&:network_bindings).flatten.map(&:host_port).first
  end

  def exist?
    task.present?
  end

  private

  def task
    @task ||= ecs.wait_until(
      :tasks_running,
      tasks: [arn],
      cluster: Settings.aws.ecs.cluster_name,
    ).dig(:tasks, 0)
  end

  def ecs
    @ecs ||= Aws::ECS::Client.new(region: Settings.aws.region)
  end

  def ec2
    @ec2 ||= Aws::EC2::Client.new(region: Settings.aws.region)
  end
end
