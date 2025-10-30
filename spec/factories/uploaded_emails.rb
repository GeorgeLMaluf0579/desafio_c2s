FactoryBot.define do
  factory :uploaded_email do
    filename { Faker::File.file_name }
    from { Faker::Internet.email }
    to { Faker::Internet.email }
    status { :queued } # queued
  end
end
