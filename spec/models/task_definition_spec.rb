require 'rails_helper'

RSpec.describe TaskDefinition, type: :model do
  describe '.register!' do
    subject { TaskDefinition.register!(repository, params) }

    let(:repository) { 'test/app' }
    let(:params) { { hoge: :fuga } }
    let(:response) { { task_definition: { family: 'example' } } }

    before do
      expect_any_instance_of(Aws::ECS::Client).to receive(:register_task_definition).with(params).and_return(response)
    end

    context "when same repository's task_definition is already exist" do
      let!(:task_definition) { FactoryGirl.create(:task_definition, repository: 'test/app', name: 'example') }

      it { expect { subject }.to raise_error(ActiveRecord::RecordInvalid) }
    end

    context "when same repository's task_definition is not exist" do
      it { expect { subject }.to change { TaskDefinition.count }.to(1).from(0) }
      it { is_expected.to have_attributes(repository: 'test/app', name: 'example') }
    end
  end
end
