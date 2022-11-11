require 'rails_helper'

RSpec.describe Friendship, type: :model do
  subject(:friendship) { create(:friendship) }

  describe 'using standard factory' do
    it { should be_valid }
  end

  describe 'validations' do
    it { should validate_uniqueness_of(:user_id).scoped_to(:friend_id) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:friend).class_name('User').with_foreign_key(:friend_id) }
    it { should have_many(:notifications) }
  end

  describe 'notifications creation callbacks' do
    context 'when it is created should create a new request notification' do
      it { expect(friendship.notifications.first.body).to match(/New Friend Request/) }
    end

    context 'when it is updated should create an accepted request notification' do
      before { friendship.update(accepted: true) }

      it { expect(friendship.notifications.last.body).to match(/accepted your friend request/) }
    end
  end
end
