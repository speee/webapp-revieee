class Api::WebhooksController < Api::ApplicationController
  def github_callback
    event_name = request.headers.fetch('X-GitHub-Event')
    payload = JSON.parse(request.body.read)
    action = PullRequest::Actions.build(event_name: event_name, payload: payload)

    if action
      pid = fork do
        fork do
          action.handle
        end
      end
      Process.waitpid(pid)
    end

    head :ok
  end
end
