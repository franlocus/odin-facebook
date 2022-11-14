require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { create(:user) }
  let!(:friend_of_user) { create(:user) }
  let!(:example_friendship) { create(:friendship, user:, friend: friend_of_user) }

  describe 'using standard factory' do
    it { should be_valid }
  end

  describe 'validations' do
    it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }
    it { should allow_value('good@email.com').for(:email) }
    it { should_not allow_value('bademail.com', '', 'foo@bar').for(:email) }
    it { should allow_value('foobar').for(:password) }
    it { should_not allow_value(' ').for(:password) }
  end

  describe 'associations' do
    it { should have_many(:friendships).dependent(:destroy).inverse_of(:user) }
    it { should have_many(:accepted_friendships).class_name('Friendship') }
    it { should have_many(:notifications).with_foreign_key(:recipient_id).dependent(:destroy) }
    it { should have_many(:posts).dependent(:destroy) }
    it { should have_many(:likes).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_one(:profile).dependent(:destroy) }
  end

  describe 'friendships' do
    context 'when user signed up' do
      it 'has no friendships' do
        new_user = create(:user)
        expect(new_user.friendships).to be_empty
      end
    end

    context 'when have sent friendships' do
      it { expect(user.friendships).not_to be_empty }
    end

    context 'when a friendship has been accepted' do
      before do
        example_friendship.update_column(:accepted, true)
      end

      it { expect(user.accepted_friendships).not_to be_empty }
    end
  end

  describe 'notifications' do
    context 'when user signs up' do
      it { expect(user.notifications).to be_empty }
    end

    context 'when receives a notification' do
      before 'create a new friendship request to send notification' do
        create(:friendship, user: create(:user), friend: user)
      end
      it { expect(user.notifications.count).to eq(1) }
    end
  end

  describe '#friends' do
    it 'should not be present in his friends list' do
      expect(user.friends).to_not eq([user])
    end
    context 'when no friendship is accepted' do
      it { expect(user.friends).to be_empty }
    end

    context 'when a friendship is accepted' do
      it do
        example_friendship.update_column(:accepted, true)
        expect(user.friends.count).to eq(1)
      end
    end
  end
end
