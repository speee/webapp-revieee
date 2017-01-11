class PullRequest::Actions::Close < PullRequest::Actions
  def handle
    return unless target.delete

    PullRequest::Comment.new.add(
      repository: payload.head_repository,
      pr_number: payload.pr_number,
      message: 'ReviewAppsを削除しました',
    )
  end
end
