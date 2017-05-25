class RevieeeTarget
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
    return if task.nil?

    task.stop
    task.destroy
    self
  end

  def update
    delete
    create
  end

  def task_definition
    TaskDefinition.find_by(repository: repository) || create_task_definition!
  end

  def task
    @task ||= Task.find_by_revieee_target(self)
  end

  def clear_nginx_cache
    cache_clear_urls.each do |url|
      Net::HTTP.get url
    end
  end

  private

  def create_task_definition!
    loader = TaskDefinitionLoader.new(self)
    TaskDefinition.register!(repository, loader.load)
  end

  def cache_clear_urls
    task.endpoints.map do |endpoint|
      URI(endpoint.url).merge('/revieee/clear')
    end
  end
end
