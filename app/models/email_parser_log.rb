class EmailParserLog < ApplicationRecord
  belongs_to :uploaded_email
  enum level: { error: "ERROR", info: "INFO", warning: "WARN" }
end
