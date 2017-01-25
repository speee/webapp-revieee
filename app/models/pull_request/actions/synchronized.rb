class PullRequest::Actions::Synchronized < PullRequest::Actions
  def handle
    return unless target.update

    cache_clear_url = "#{target.endpoint}/review_apps/clear"
    Net::HTTP.get URI.parse(cache_clear_url)
  end
end
