class PullRequest::Actions::Synchronized < PullRequest::Actions
  def handle
    target.update
  end
end
