class PullRequest::Actions::Close < PullRequest::Actions
  def handle
    target.clear_nginx_cache

    return unless target.delete
    add_comment('ReviewAppsを削除しました')
  end
end
