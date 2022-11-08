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

    context 'when user is destroyed dependent friendships too' do
      it do
        expect { user.destroy }.to change { friend.friendships.count }.by(-1)
      end
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
      it 'should have one' do
        expect(user.notifications.count).to eq(1)
      end
    end
  end

  describe 'posts' do
    context 'when user creates a post' do
      it 'should belong to him' do
        expect(create(:post, author: user).author).to eq(user)
      end
    end

    context 'when user is destroyed dependent posts too' do
      it do
        post = create(:post, author: user)
        user.destroy
        expect {post.reload}.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '#friends' do
    context 'when a friendship is not accepted' do
      it { expect(user.friends).to be_empty }
    end

    context 'when a friendship is accepted' do
      it do
        expect { friendship.update_column(:accepted, true) }.to change { user.friends } 
      end
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
