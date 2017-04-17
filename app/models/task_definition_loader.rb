class TaskDefinitionLoader
  CONFIG_FILE = 'task_definition.yml'.freeze

  def initialize(review_app_target)
    @review_app_target = review_app_target
  end

  def load
    github = Octokit::Client.new(access_token: Settings.github.access_token)
    begin
      response = github.contents(
        @review_app_target.repository,
        path: CONFIG_FILE,
        ref: @review_app_target.branch,
      )
    rescue Octokit::NotFound
      {}
    else
      parse_response(response)
    end
  end

  private

  def parse_response(response)
    YAML.load(Base64.decode64(response[:content])).deep_symbolize_keys
  end
end
