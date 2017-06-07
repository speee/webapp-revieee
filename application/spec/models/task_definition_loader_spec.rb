require 'rails_helper'

RSpec.describe TaskDefinitionLoader, type: :model do
  describe '#load' do
    subject { task_definition_loader.load }

    let(:task_definition_loader) { TaskDefinitionLoader.new(revieee_target) }
    let(:revieee_target) { RevieeeTarget.new(repository: 'test/app', branch: 'patch') }

    let(:response) { { content: Base64.encode64('task_definition: test') } }

    it 'call github api rightly' do
      expect_any_instance_of(Octokit::Client).to receive(:contents).with(
        'test/app',
        path: 'task_definition.yml',
        ref: 'patch',
      ).and_return(response)
      subject
    end

    context 'when content is not found in github' do
      before { allow_any_instance_of(Octokit::Client).to receive(:contents).and_raise(Octokit::NotFound) }

      let(:expected) { {} }

      it { is_expected.to eq expected }
    end

    context 'when content found' do
      before { allow_any_instance_of(Octokit::Client).to receive(:contents).and_return(response) }

      let(:expected) { { task_definition: 'test' } }

      it { is_expected.to eq expected }
    end
  end
end
