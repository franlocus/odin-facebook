require 'rails_helper'

RSpec.describe User, type: :model do
  context "devise validations" do
    it "must have a valid email format" do
      expect { create(:user, email: 'snackeater.com') }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "must have a password" do
      expect { create(:user, password: '') }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "will be created having email and password" do
      expect { create(:user) }.to_not raise_error
    end
  end

  context 'friendships' do
    let!(:user) { create(:user) }
    let!(:friend) { create(:user) }
    let!(:friendship) { create(:friendship, user:, friend:) }

    it 'starts with no friendships' do
      new_user = create(:user)
      expect(new_user.friendships).to be_empty
    end

    it 'can have sent friendships' do
      expect(user.friendships).to_not be_empty
    end

    it 'can have an accepted friendship if the friend accepts it' do
      friendship.update_column(:accepted, true)

      expect(user.accepted_friendships).to_not be_empty
    end
  end

  context '#friends' do
    let!(:user) { create(:user) }
    let!(:friend) { create(:user) }

    it 'will not have a friend until the friendship is accepted' do
      friendship = create(:friendship, user:, friend:, accepted: false)
      expect(user.friends).to be_empty
      friendship.update_column(:accepted, true)
      expect(user.friends.first).to eq(friend)
    end
  end

  it "has an empty profile after registration" do
    user = create(:user)
    user.profile.attributes.each do |name, value|
      next if name.match?(/id|_at/)

      expect(value).to be_nil
    end
  end
end
