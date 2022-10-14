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

  it "has an empty profile after registration" do
    user = create(:user)
    user.profile.attributes.each do |name, value|
      next if name.match?(/id|_at/)

      expect(value).to be_nil
    end
  end
end
