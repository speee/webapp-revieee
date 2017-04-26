class PullRequest::Actions::Synchronized < PullRequest::Actions
  def handle
    return unless target.update

    target.cache_clear_urls.each do |url|
      Net::HTTP.get URI.parse(url)
    end

    add_comment(message)
  end

  private

  def message
    target.task.endpoints.map(&:url).join("\n")
  end
end
