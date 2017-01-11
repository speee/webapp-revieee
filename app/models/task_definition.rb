class TaskDefinition
  include ActiveModel::Model

  attr_accessor :review_app_target

  def exist?
    ecs.list_task_definition_families.families.include?(review_app_target.task_definition_name)
  end

  def run
    task_arn = run_task
    Task.new(arn: task_arn) if task_arn
  end

  private

  def run_task
    ecs.run_task(
      cluster: Settings.aws.ecs.cluster_name,
      task_definition: get_latest_arn,
      overrides: {
        container_overrides: [
          {
            name: 'rails',
            environment: [
              {
                name: 'BRANCH',
                value: review_app_target.branch,
              },
            ],
          },
        ],
      },
    ).dig(:tasks, 0, :task_arn)
  end

  def get_latest_arn
    ecs.list_task_definitions(
      family_prefix: review_app_target.task_definition_name,
      status: 'ACTIVE',
      sort: 'DESC',
      max_results: 1,
    ).dig(:task_definition_arns, 0)
  end

  def ecs
    @ecs ||= Aws::ECS::Client.new(region: Settings.aws.region)
  end
end
