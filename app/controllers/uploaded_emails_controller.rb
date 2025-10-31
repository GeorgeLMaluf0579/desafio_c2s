class UploadedEmailsController < ApplicationController
  def index
    @uploaded_emails = UploadedEmail.select(:from, :to, :status).order(created_at: :desc)
  end

  def new; end

  def create

    uploaded_file = params.require(:email_file)
    
    unless uploaded_file.original_filename.downcase.end_with?(".eml") && uploaded_file.content_type == "message/rfc822"
      flash[:alert] = "O arquivo deve ser um email (.eml) valido"
      redirect_to new_uploaded_email_path and return
    end

    uploaded_email = UploadedEmail.create!(
      filename: uploaded_file.original_filename,
      eml_file: uploaded_file
    )

    begin
      email = Mail.read(uploaded_file.tempfile.path)
      uploaded_email.update(
        from: Array(email.from).first.to_s,
        to: Array(email.to).first.to_s
      )

    rescue => e
      Rails.logger.error "Falha ao ler cabecalho do e-email: #{e.message}"
    end
    EmailProcessorJob.perform_async(uploaded_email.id)
    redirect_to uploaded_emails_path, notice: "Arquivo enviado para a fila de processamento"
  end
end
