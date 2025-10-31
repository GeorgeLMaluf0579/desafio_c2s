class EmailProcessorJob
  include Sidekiq::Job
  sidekiq_options retry: 3

  def perform(uploaded_email_id)
    uploaded_email = UploadedEmail.find_by(id: uploaded_email_id)
    return Rails.logger.error("UploadedEmail #{uploaded_email_id} nao encontrado") unless uploaded_email

    EmailProcessorService.new(uploaded_email).process
  rescue => e
    Rails.logger.error("EmailProcessorJob failed for ##{uploaded_email_id}: #{e.class} - #{e.message}")
    raise
  end
end