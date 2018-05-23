FactoryBot.define do
  factory :comment do
    association :author, factory: :user
    movie
    body { Faker::Lorem.sentence }
  end
end
