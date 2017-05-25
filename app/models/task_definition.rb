class TaskDefinition < ApplicationRecord
  include AwsAccessible

  has_many :tasks

  validates :repository, presence: true, uniqueness: true
  validates :name, presence: true

  class << self
    def register!(repository, params)
      ecs = Aws::ECS::Client.new(region: Settings.aws.region)
      response = ecs.register_task_definition(params)
      create!(
        repository: repository,
        name: response.dig(:task_definition, :family),
      )
    end
  end

  def exist?
    ecs.list_task_definition_families.families.include?(name)
  end

  def run(revieee_target)
    task_arn = run_task(revieee_target)
    if task_arn
      task = tasks.build(
        arn: task_arn,
        pr_number: revieee_target.pr_number,
      )
      task if task.save
    end
  end

  private

  def run_task(revieee_target)
    ecs.run_task(
      cluster: Settings.aws.ecs.cluster_name,
      task_definition: latest_arn,
      overrides: {
        container_overrides: [
          {
            name: 'main',
            environment: [
              {
                name: 'BRANCH',
                value: revieee_target.branch,
              },
            ],
          },
        ],
      },
    ).dig(:tasks, 0, :task_arn)
  end

  def latest_arn
    ecs.list_task_definitions(
      family_prefix: name,
      status: 'ACTIVE',
      sort: 'DESC',
      max_results: 1,
    ).dig(:task_definition_arns, 0)
  end
end
