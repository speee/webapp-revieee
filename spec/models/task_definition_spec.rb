require 'rails_helper'

RSpec.describe TaskDefinition, type: :model do
  describe '.find_or_create_by_review_app_target!' do
    subject { TaskDefinition.find_or_create_by_review_app_target!(review_app_target) }

    let(:review_app_target) { ReviewAppTarget.new(repository: 'test/app') }

    context 'when TaskDefinition is already exist' do
      let!(:task_definition) { FactoryGirl.create(:task_definition, repository: 'test/app', name: 'example') }

      it { is_expected.to eq task_definition }
    end

    context 'when TaskDefinition is not exist' do
      let(:task_definition_config) { TaskDefinitionConfig.new(content: {}) }

      before do
        allow(TaskDefinitionConfig).to receive(:load_from_review_app_target).and_return(task_definition_config)
        allow(TaskDefinition).to receive(:register).and_return('test-task-definition')
      end

      it { is_expected.to have_attributes(repository: 'test/app', name: 'test-task-definition') }
    end
  end
end
