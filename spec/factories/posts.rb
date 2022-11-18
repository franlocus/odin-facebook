FactoryBot.define do
  factory :post do
    author
    content { 'Yay my first post!' }
  end
end
