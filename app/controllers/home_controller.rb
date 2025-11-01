class HomeController < ApplicationController
  def index
    @clients_count = Customer.select(:id).count
    @uploaded_emails = UploadedEmail.select(:id).count
    @uploaded_emails_success = UploadedEmail.select(:id).where(status: :success).count
    @uploaded_emails_fails = UploadedEmail.select(:id).where(status: :fail).count
  end
end
