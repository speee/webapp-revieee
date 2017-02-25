require 'rails_helper'

RSpec.describe SpotFleetRequest::SpotInstance, :type => :model do
  describe '#initialize' do
    subject(:spot_instance) { SpotFleetRequest::SpotInstance.new }

    context 'when keywords arguments were given' do
      it 'instance variables were overwritten by keyword arguments'
    end

    context 'when keywords arguments were not given' do
      it 'instance variables have default values'
    end
  end
end
