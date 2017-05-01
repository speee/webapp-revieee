class PullRequest::Actions::Synchronized < PullRequest::Actions
  def handle
    target.cache_clear_urls.each do |url|
      Net::HTTP.get url
    end

    return unless target.update

    add_comment(message)
  end

  private

  def message
    target.task.endpoints.map(&:url).join("\n")
  end
end
