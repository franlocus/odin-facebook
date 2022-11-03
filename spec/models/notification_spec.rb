require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe 'factory' do
    context 'when using standard factory' do
      it {  expect(build(:notification, :for_friendship)).to be_valid }
      it {  expect(build(:notification, :for_comment)).to be_valid }
      it {  expect(build(:notification, :for_like)).to be_valid }
    end
  end

  describe 'belongs to recipient ' do
    context 'when doesnt have recipient' do
      it { expect(build(:notification, recipient: nil)).not_to be_valid }
    end

    context 'when recipient is destroyed' do
      it 'should be destroyed too' do
        recipient = create(:user)
        notification = create(:notification, :for_friendship, recipient:)
        recipient.destroy
        expect { notification.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
