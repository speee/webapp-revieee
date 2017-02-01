class PullRequest::Actions::Synchronized < PullRequest::Actions
  def handle
    return unless target.update

    Net::HTTP.get URI.parse(target.cache_clear_url)
  end
end
