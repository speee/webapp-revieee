class PullRequest::Actions::Open < PullRequest::Actions
  def handle
    return unless target.create

    PullRequest::Comment.new.add(
      repository: payload.head_repository,
      pr_number: payload.pr_number,
      message: target.endpoint,
    )
  end
end
