require 'rails_helper'

RSpec.describe Friendship, type: :model do
  context 'validations' do
    it 'must have a user and friend' do
      expect { create(:friendship, friend: nil) }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'must be only one friendship between two users' do
      user = create(:user)
      friend = create(:user)
      create(:friendship, user:, friend:)
      expect { create(:friendship, user:, friend:) }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
