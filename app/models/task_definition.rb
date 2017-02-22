class TaskDefinition < ApplicationRecord
  attr_accessor :review_app_target

  validates :repository, presence: true, uniqueness: true
  validates :name, presence: true

  def exist?
    ecs.list_task_definition_families.families.include?(review_app_target.task_definition_name)
  end

  def run
    task_arn = run_task
    if task_arn
      Task.new(
        arn: task_arn,
        repository: review_app_target.repository,
        pr_number: review_app_target.pr_number,
      )
    end
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
