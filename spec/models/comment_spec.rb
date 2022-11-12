require 'rails_helper'

RSpec.describe Comment, type: :model do
  subject(:comment) { create(:comment) }

  describe 'using standard factory' do
    it { should be_valid }
  end

  describe 'validations' do
    it { should validate_presence_of(:body) }
  end

  describe 'associations' do
    it { should belong_to(:commenter).class_name('User') }
    it { should belong_to(:post) }
    it { should have_many(:notifications) }
  end

  describe 'notifications creation callback' do
    context 'when it is created should create a new comment notification' do
      before { @notifications_recipients_ids = subject.notifications.pluck(:recipient_id) }

      it 'for post author' do
        expect(@notifications_recipients_ids).to include(subject.post.author.id)
      end

      it 'for others commenters' do
        commenters = subject.post.comments.pluck(:user_id).tap { |users_ids| users_ids.delete(subject.commenter.id) }
        expect(@notifications_recipients_ids).to include(*commenters)
      end

      it 'should not create a notification for the commenter' do
        expect(@notifications_recipients_ids).to_not include(subject.commenter.id)
      end
    end
  end
end
