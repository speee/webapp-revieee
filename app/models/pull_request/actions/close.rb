class PullRequest::Actions::Close < PullRequest::Actions
  def handle
    return unless target.delete

    target.cache_clear_urls.each do |url|
      Net::HTTP.get URI.parse(url)
    end

    add_comment('ReviewAppsを削除しました')
  end
end
