class TaskDefinitionConfig
  include ActiveModel::Model

  CONFIG_FILE = 'task_definition.yml'.freeze

  attr_accessor :content

  class << self
    def load_from_review_app_target(review_app_target)
      response = load_github_content(
        repository: review_app_target.repository,
        branch: review_app_target.branch,
        path: CONFIG_FILE,
      )
      content = parse_content(response)
      new(content: content)
    end

    private

    def parse_content(response)
      return {} if response.blank?
      YAML.load(Base64.decode64(response[:content]))
    end

    def load_github_content(repository:, branch:, path:)
      github = Octokit::Client.new(access_token: Settings.github.access_token)
      github.contents(repository, path: path, ref: branch)
    rescue Octokit::NotFound
    end
  end
end
