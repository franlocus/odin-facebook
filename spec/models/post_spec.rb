require 'rails_helper'

RSpec.describe Post, type: :model do
  subject(:post) { create(:post) }

  describe 'using standard factory' do
    it { should be_valid }
  end

  describe 'associations' do
    it { should belong_to(:author).class_name('User').with_foreign_key(:user_id) }
    it { should have_many(:likes).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many_attached(:images) }
  end

  describe 'validations' do
    it { should validate_presence_of(:content) }

    context 'when does not have content but has an image' do
      it do
        subject.images.attach(
          io: File.open(Rails.root.join('spec', 'factories', 'example_image.jpeg')),
          filename: 'example_image.jpg',
        )
        should_not validate_presence_of(:content)
      end
    end
  end

  describe '#author_and_commenters_ids' do
    it 'should return the author and commenters ids' do
      commenters_ids = post.comments.distinct.pluck(:user_id)
      expect(post.author_and_commenters_ids).to eq((commenters_ids << post.author.id).uniq)
    end
  end
end
