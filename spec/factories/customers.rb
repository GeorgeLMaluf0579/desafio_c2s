FactoryBot.define do
  factory :customer do
    name { Faker::Name }
    email { Faker::Internet.email }
    phone { Faker::PhoneNumber }
    product_code { Faker::Commerce.bothify('PROD-????-####') }
    subject { Faker::Company.catch_phrase }
  end
end
