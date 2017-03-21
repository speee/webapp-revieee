class PullRequest::Actions::Synchronized < PullRequest::Actions
  def handle
    return unless target.update

    Net::HTTP.get URI.parse(target.cache_clear_url)

    add_comment(message)
  end

  private

  def message
    target.task.endpoints.map(&:url).join("\n")
  end
end
