require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe 'factory' do
    context 'when using standard factory' do
      it {  expect(build(:notification, :for_friendship)).to be_valid }
      it {  expect(build(:notification, :for_comment)).to be_valid }
      it {  expect(build(:notification, :for_like)).to be_valid }
    end
  end

  describe 'associations' do
    it { should belong_to(:recipient).class_name('User') }
    it { should belong_to(:notifiable) }
  end

  describe 'scope unread' do
    it do
      example_unread_notification = create(:notification, :for_friendship)

      expect(Notification.unread).to include(example_unread_notification)
    end
  end
end
