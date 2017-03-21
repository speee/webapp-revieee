class PullRequest::Actions::Open < PullRequest::Actions
  def handle
    return unless target.create

    add_comment(message)
  end

  private

  def message
    target.task.endpoints.map(&:url).join("\n")
  end
end
