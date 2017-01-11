class PullRequest::Actions
  attr_reader :payload
  attr_accessor :target

  def self.build(event_name: nil, payload: nil)
    return nil if event_name != 'pull_request'

    pull_request_payload = PullRequest::Payload.new(payload)

    # TODO: refactoring
    case pull_request_payload
    when :opened?.to_proc
      PullRequest::Actions::Open.new(pull_request_payload)
    when :closed?.to_proc
      PullRequest::Actions::Close.new(pull_request_payload)
    when :synchronized?.to_proc
      PullRequest::Actions::Synchronized.new(pull_request_payload)
    else
      puts 'not implemented actions' # TODO: return correct API response
    end
  end

  def initialize(payload)
    @payload = payload
  end

  def handle
    raise 'Not implemented Error'
  end

  private

  def target
    @target ||= ReviewAppTarget.new(repository: payload.head_repository, branch: payload.head_branch, pr_number: payload.pr_number)
  end
end
