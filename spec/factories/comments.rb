FactoryBot.define do
  factory :comment do
    commenter
    post
    body { 'Nice post buddy!' }
  end
end
