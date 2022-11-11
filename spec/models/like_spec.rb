require 'rails_helper'

RSpec.describe Like, type: :model do
  subject(:like) { create(:like) }

  describe 'using standard factory' do
    it { should be_valid }
  end

  describe 'validations' do
    it { should validate_uniqueness_of(:user_id).scoped_to(:post_id) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:post).counter_cache(true) }
    it { should have_one(:notification) }
  end

  describe 'notifications creation callback' do
    context 'when it is created should create a new like notification for author' do
      it { expect(like.notification.body).to match(/likes your post/) }
    end

    context 'when the author likes his own post should not create a new notification' do
      it do
        example_user = create(:user)
        example_post = create(:post, author: example_user)
        auto_like = create(:like, post: example_post, user: example_user)
        expect(auto_like.notification).to be_nil
      end
    end
  end
end
