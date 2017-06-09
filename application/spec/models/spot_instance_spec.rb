require 'rails_helper'

RSpec.describe SpotFleetRequest::SpotInstance, :type => :model do
  describe '#initialize' do
    subject { SpotFleetRequest::SpotInstance.new(args: keyword_arguments) }
    let(:keyword_arguments) { Hash.new }

    let(:expected_attributes) do
      {
        iam_instance_profile: SpotFleetRequest::SpotInstance::IAM_INSTANCE_PROFILE,
        instance_type: SpotFleetRequest::SpotInstance::INSTANCE_TYPE,
        image_id: SpotFleetRequest::SpotInstance::IMAGE_ID,
        key_name: SpotFleetRequest::SpotInstance::KEY_NAME,
        group_id: SpotFleetRequest::SpotInstance::GROUP_ID
      }
    end

    context 'when keywords arguments were not given' do
      it 'instance variables have default values' do
        is_expected.to have_attributes(expected_attributes)
      end
    end

    context 'when keywords arguments were given' do
      let(:keyword_arguments) do
        {
          iam_instance_profile: 'sample instance profile',
          instance_type: 'sample instance',
          image_id: 'sample image id',
          key_name: 'sample key name',
          group_id: 'sample group_id'
        }
      end

      let(:expected_attributes) { keyword_arguments }

      it 'instance variables were overwritten by keyword arguments' do
        is_expected.to have_attributes(expected_attributes)
      end
    end
  end
end
