class Api::WebhooksController < Api::ApplicationController
  before_action :authenticate

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

  private

  def authenticate
    head :unauthorized unless valid_signature?
  end

  def valid_signature?
    github_signature = request.headers.fetch('X-Hub-Signature')
    return false unless github_signature

    signature = "sha1=#{OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), Settings.github.webhook_secret, request.body.read)}"
    Rack::Utils.secure_compare(signature, github_signature)
  end
end
