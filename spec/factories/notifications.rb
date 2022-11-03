FactoryBot.define do
  factory :notification do
    recipient

    trait :for_friendship do
      association :notifiable, factory: :friendship
    end

    trait :for_comment do
      association :notifiable, factory: :comment
    end

    trait :for_like do
      association :notifiable, factory: :like
    end
  end
end
