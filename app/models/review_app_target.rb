class ReviewAppTarget
  include ActiveModel::Model

  TASK_DEFINITION_MAPS = {
  }.freeze

  attr_accessor :repository, :branch, :pr_number

  validates :repository, presence: true
  validates :branch, presence: true
  validates :pr_number, presence: true

  def endpoint
    "http://#{task_info.subdomain}.#{Settings.domain}/"
  end

  def create
    task = task_definition.run
    if task
      @task_info = TaskInfo.new(review_app_target: self, task: task)
      task_info.save
      self
    end
  end

  def delete
    task_info.task.stop
    task_info.delete
    self
  end

  def task_definition
    @task_definition ||= TaskDefinition.new(review_app_target: self)
  end

  def task_info
    @task_info ||= TaskInfo.new(review_app_target: self)
  end

  def task_definition_name
    @task_definition_name = TASK_DEFINITION_MAPS.fetch(repository)
  end
end
