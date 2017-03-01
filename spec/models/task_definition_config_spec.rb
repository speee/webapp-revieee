require 'rails_helper'

RSpec.describe TaskDefinitionConfig, type: :model do
  describe '.load_from_review_app_target' do
    let(:review_app_target) { ReviewAppTarget.new }
    let(:response) { { content: Base64.encode64('task_definition: test') } }

    before { allow_any_instance_of(Octokit::Client).to receive(:contents).and_return(response) }

    subject { TaskDefinitionConfig.load_from_review_app_target(review_app_target) }

    it { is_expected.to have_attributes(content: { task_definition: 'test' }) }
  end

  describe '#to_hash' do
    subject { TaskDefinitionConfig.new(content: { test: 1 }).to_hash }

    it { is_expected.to eq test: 1 }
  end
end
