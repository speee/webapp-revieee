class PullRequest::Payload
  attr_reader :payload

  def initialize(payload)
    @payload = payload
  end

  def opened?
    @payload['action'] == 'opened'
  end

  def closed?
    @payload['action'] == 'closed'
  end

  def synchronized?
    @payload['action'] == 'synchronize'
  end

  def pr_number
    @payload['number']
  end

  def head_branch
    @payload['pull_request']['head']['ref']
  end

  def head_repository
    @payload['pull_request']['head']['repo']['full_name']
  end

  def base_branch
    @payload['pull_request']['base']['ref']
  end

  def base_repository
    @payload['pull_request']['base']['repo']['full_name']
  end
end
