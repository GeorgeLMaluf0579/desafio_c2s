class UploadedEmailsController < ApplicationController
  def index
    @uploaded_emails = UploadedEmail.select(:from, :to, :status).order(created_at: :desc)
  end
end
