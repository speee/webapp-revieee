class PullRequest::Actions::Open < PullRequest::Actions
  def handle
    return unless target.create

    PullRequest::Comment.new.add(
      repository: payload.head_repository,
      pr_number: payload.pr_number,
      message: message,
    )
  end

  private

  def message
    target.task.endpoints.map(&:url).join("\n")
  end
end
