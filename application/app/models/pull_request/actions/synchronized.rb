class PullRequest::Actions::Synchronized < PullRequest::Actions
  def handle
    target.clear_nginx_cache
    return unless target.update

    add_comment(message)
  end

  private

  def message
    target.task.endpoints.map(&:url).join("\n")
  end
end
