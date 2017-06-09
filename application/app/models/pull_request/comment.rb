class PullRequest::Comment
  def add(repository:, pr_number:, message:)
    client.add_comment(repository, pr_number, message)
  end

  private

  def client
    @client ||= Octokit::Client.new(access_token: Settings.github.access_token)
  end
end
