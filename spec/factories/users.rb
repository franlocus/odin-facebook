FactoryBot.define do
  factory :user, aliases: [:recipient] do
    sequence :email do |n|
      "odiniter-#{n}@mail.com"
    end
    password { "hardworker2022" }
  end
end
