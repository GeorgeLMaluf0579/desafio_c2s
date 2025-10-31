class EmailProcessorJob
  include Sidekiq::Job
  sidekiq_options retry: 3

  def perform(uploaded_email_id)
    uploaded_email = UploadedEmail.find(uploaded_email_id)
    EmailProcessorService.new(uploaded_email).process
  end
end