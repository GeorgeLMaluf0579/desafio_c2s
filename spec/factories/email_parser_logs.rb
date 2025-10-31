FactoryBot.define do
  factory :email_parser_log do
    association :uploaded_email
    extracted_data { { subject: "Test Email", sender: "john@example.com" }.to_json }
    level { "INFO" }
    error_message { "Default info message" }

    trait :error_level do
      level { "ERROR" }
      error_message { "This is an error level message" }
    end

    trait :info_level do
      level { "INFO" }
      error_message { "This is an information level message" }
    end

    trait :warning_level do
      level { "WARN" }
      error_message { "This is a warning level message" }
    end
  end
end
