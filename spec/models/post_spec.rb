require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'factory' do
    context 'when using standard factory' do
      let!(:post) { create(:post) }

      it 'should be valid, with likes and comements' do
        expect(post).to be_valid
        expect(post.likes.count).to eq(3)
        expect(post.comments.count).to eq(2)
      end
    end
  end
end
