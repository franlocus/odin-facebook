require 'rails_helper'

RSpec.describe Profile, type: :model do
  subject(:profile) { create(:user).profile }

  describe 'using standard factory' do
    it { should be_valid }
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_one_attached(:photo) }
  end

  it 'starts with empty fields ' do
    profile.attributes.each do |name, value|
      next if name.match?(/id|_at/)

      expect(value).to be_nil
    end
  end
end
