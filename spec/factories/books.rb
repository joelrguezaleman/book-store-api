FactoryBot.define do
  factory :book do
    title { Faker::Book.title }
    pages { Faker::Number.between(100, 1000) }
    authors { [create(:author, name: Faker::Name.name)] }
    genres { [create(:genre, name: Faker::Book.genre)] }
    publisher { create(:publisher, name: Faker::Company.name) }
  end
end