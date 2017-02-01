class ReviewAppTarget
  include ActiveModel::Model

  attr_accessor :repository, :branch, :pr_number

  validates :repository, presence: true
  validates :branch, presence: true
  validates :pr_number, presence: true

  def endpoint
    "http://#{task_info.subdomain}.#{Settings.domain}/"
  end

  def create
    @task = task_definition.run
    if @task && @task.save
      self
    end
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
    @task_definition ||= TaskDefinition.new(review_app_target: self)
  end

  def task
    @task ||= Task.find_by_review_app_target(self)
  end

  def task_definition_name
    @task_definition_name = Settings.task_definition_maps[repository]
  end

  def cache_clear_url
    "#{target.endpoint}/review_apps/clear"
  end
end
