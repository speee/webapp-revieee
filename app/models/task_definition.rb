class TaskDefinition < ApplicationRecord
  has_many :tasks

  validates :repository, presence: true, uniqueness: true
  validates :name, presence: true

  class << self
    def find_or_create_by_review_app_target!(review_app_target)
      find_by(repository: review_app_target.repository) || create_by_review_app_target!(review_app_target)
    end

    private

    def create_by_review_app_target!(review_app_target)
      config = TaskDefinitionConfig.load_from_review_app_target(review_app_target)
      name = register(config.to_hash)
      create!(repository: review_app_target.repository, name: name)
    end

    def register(options)
      ecs = Aws::ECS::Client.new(region: Settings.aws.region)
      ecs.register_task_definition(options).dig(:task_definition, :family)
    end
  end

  def exist?
    ecs.list_task_definition_families.families.include?(name)
  end

  def run(review_app_target)
    task_arn = run_task(review_app_target)
    if task_arn
      task = tasks.build(
        arn: task_arn,
        pr_number: review_app_target.pr_number,
      )
      task if task.save
    end
  end

  private

  def run_task(review_app_target)
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
                value: review_app_target.branch,
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

  def ecs
    @ecs ||= Aws::ECS::Client.new(region: Settings.aws.region)
  end
end
