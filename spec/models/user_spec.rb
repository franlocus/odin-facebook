require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'factory' do
    context 'when using standard factory' do
      it { expect(build(:user)).to be_valid }
    end
  end

  describe 'validations' do
    context 'when user does not have valid email format' do
      it { expect(build(:user, email: 'snackeater.com')).not_to be_valid }
    end

    context 'when user does not have valid password' do
      it { expect(build(:user, password: '')).not_to be_valid }
    end
  end

  let!(:user) { create(:user) }
  let!(:friend) { create(:user) }
  let!(:friendship) { create(:friendship, user:, friend:) }

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
        friendship.update_column(:accepted, true)
      end

      it { expect(user.accepted_friendships).not_to be_empty }
    end
  end

  describe '#friends' do
    context 'when a friendship is not accepted' do
      it { expect(user.friends).to be_empty }
    end

    context 'when a friendship is accepted' do
      before do
        friendship.update_column(:accepted, true)
      end

      it { expect(user.friends).not_to be_empty }
    end
  end

  describe 'profile creation callback' do
    context 'when user signs up' do
      it 'has a profile with empty fields' do
        user.profile.attributes.each do |name, value|
          next if name.match?(/id|_at/)

          expect(value).to be_nil
        end
      end
    end
  end
end
