class PullRequest::Actions::Close < PullRequest::Actions
  def handle
    return unless target.delete

    add_comment('ReviewAppsを削除しました')
  end
end
