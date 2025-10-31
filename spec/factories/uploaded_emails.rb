FactoryBot.define do
  factory :uploaded_email do
    filename { Faker::File.file_name }
    from { Faker::Internet.email }
    to { Faker::Internet.email }
    status { :queued } 


    trait :with_full_fornecedor_a do
      after(:build) do |uploaded_email|
        uploaded_email.eml_file.attach(
          io: File.open(Rails.root.join('spec', 'fixtures', 'emails', 'email1.eml')),
          filename: 'email1.eml',
          content_type: 'message/rfc822'
        )
      end
    end

    trait :with_full_parceiro_b do
      after(:build) do |uploaded_email|
        uploaded_email.eml_file.attach(
          io: File.open(Rails.root.join('spec', 'fixtures', 'emails', 'email4.eml')),
          filename: 'email4.eml',
          content_type: 'message/rfc822'
        )
      end
    end

    trait :without_email_contact do
      after(:build) do |uploaded_email|
        uploaded_email.eml_file.attach(
          io: File.open(Rails.root.join('spec', 'fixtures', 'emails', 'email6.eml')),
          filename: 'email6.eml',
          content_type: 'message/rfc822'
        )
      end
    end

    trait :with_unknow_sender do
      after(:build) do |uploaded_email|
        uploaded_email.eml_file.attach(
          io: File.open(Rails.root.join('spec', 'fixtures', 'emails', 'email9.eml')),
          filename: 'email9.eml',
          content_type: 'message/rfc822'
        )
      end
    end
  end
end
