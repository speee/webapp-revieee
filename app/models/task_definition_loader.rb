class TaskDefinitionLoader
  CONFIG_FILE = 'task_definition.yml'.freeze

  def initialize(revieee_target)
    @revieee_target = revieee_target
  end

  def load
    github = Octokit::Client.new(access_token: Settings.github.access_token)
    begin
      response = github.contents(
        @revieee_target.repository,
        path: CONFIG_FILE,
        ref: @revieee_target.branch,
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
