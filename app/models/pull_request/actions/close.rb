class PullRequest::Actions::Close < PullRequest::Actions
  def handle
    target.cache_clear_urls.each do |url|
      Net::HTTP.get URI.parse(url)
    end

    return unless target.delete
    add_comment('ReviewAppsを削除しました')
  end
end
