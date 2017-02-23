class ReviewAppTarget
  include ActiveModel::Model

  attr_accessor :repository, :branch, :pr_number

  validates :repository, presence: true
  validates :branch, presence: true
  validates :pr_number, presence: true

  def create
    @task = task_definition.run(self)
    self if @task
  end

  def delete
    task.stop
    task.destroy
    self
  end

  def update
    delete
    create
  end

  def task_definition
    @task_definition ||= TaskDefinition.find_by(repository: repository)
  end

  def task
    @task ||= Task.find_by_review_app_target(self)
  end

  def cache_clear_url
    "#{target.endpoint}/review_apps/clear"
  end
end
