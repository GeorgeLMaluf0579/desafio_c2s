class UploadedEmailsController < ApplicationController
  before_action :set_uploaded_email, only: %i[ show reprocess]

  def index
    @uploaded_emails = UploadedEmail.select(:id, :from, :to, :filename, :status).order(created_at: :desc)
  end

  def new; end

  def create
    uploaded_file = params.require(:email_file)

    unless uploaded_file.original_filename.downcase.end_with?(".eml") && uploaded_file.content_type == "message/rfc822"
      flash[:alert] = "O arquivo deve ser um email (.eml) valido"
      redirect_to new_uploaded_email_path and return
    end

    @uploaded_email = UploadedEmail.create!(
      filename: uploaded_file.original_filename,
      eml_file: uploaded_file
    )

    begin
      email = Mail.read(uploaded_file.tempfile.path)
      @uploaded_email.update(
        from: Array(email.from).first.to_s,
        to: Array(email.to).first.to_s
      )

    rescue => e
      Rails.logger.error "Falha ao ler cabecalho do e-email: #{e.message}"
    end
    EmailProcessorJob.perform_async(@uploaded_email.id)
    redirect_to uploaded_emails_path, notice: "Arquivo enviado para a fila de processamento"
  end

  def show; end

  def reprocess
    EmailProcessorJob.perform_async(@uploaded_email.id)
    redirect_to uploaded_emails_path, notice: "Reprocessamento na fila"
  end

  private

  def set_uploaded_email
    @uploaded_email = UploadedEmail.includes(:email_parser_logs).find(params[:id])
  end
end
