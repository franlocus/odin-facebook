FactoryBot.define do
  factory :post do
    author
    after :create do |post|
      create_list(:like, 3, post:)
      create_list(:comment, 2, post:)
    end
    content { 'Yay my first post!' }
  end
end
