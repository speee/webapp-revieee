class TaskInfo
  include ActiveModel::Model

  attr_accessor :review_app_target, :task

  validates :review_app_target, presence: true
  validates :task, presence: true
  validate  :task_exist?

  def save
    s3.put_object(
      bucket: Settings.aws.s3.bucket,
      key: filename,
      body: body,
      content_type: 'application/json',
    )
  end

  def delete
    s3.delete_object(
      bucket: Settings.aws.s3.bucket,
      key: filename,
    )
  end

  def subdomain
    "#{review_app_target.task_definition_name}-pr-#{review_app_target.pr_number}"
  end

  def filename
    "#{subdomain}.json"
  end

  def body
    { ip: task.private_ip, port: task.port, task_arn: task.arn }.to_json
  end

  def task
    return @task if @task

    obj = s3.get_object(
      bucket: Settings.aws.s3.bucket,
      key: filename,
    )
    return unless obj
    json = JSON.parse(obj.body.string)
    @task = Task.new(arn: json['task_arn'])
  rescue Aws::S3::Errors::NoSuchKey
  end

  private

  def task_exist?
    task.exist?
  end

  def s3
    @s3 ||= Aws::S3::Client.new(region: Settings.aws.region)
  end
end
