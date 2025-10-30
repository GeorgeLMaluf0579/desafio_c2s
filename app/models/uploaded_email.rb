class UploadedEmail < ApplicationRecord
  enum :status, {
  queued: "queued",
  processing: "processing",
  fail: "fail",
  success: "success" }, default: "queued", validate: true
end
