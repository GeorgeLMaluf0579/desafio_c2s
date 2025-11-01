class UploadedEmail < ApplicationRecord
  enum :status, {
  queued: "queued",
  processing: "processing",
  fail: "fail",
  success: "success" }, default: "queued", validate: true

  has_one_attached :eml_file
  has_many :email_parser_logs, dependent: :destroy
end
