require 'rails_helper'

RSpec.describe "UploadedEmails", type: :request do
  describe 'GET /uploaded_emails when there are uploaded emails' do
    let!(:uploaded_email_a) { create(:uploaded_email, from: "fulano@example.com", to: "beltrano@example.com", created_at: 2.hours.ago) }
    let!(:uploaded_email_b) { create(:uploaded_email, from: "jonh_doe@example.com", to: "jane_doe@example.com", created_at: 1.hour.ago) }

    it 'responds successfully and shows uploaded emails ordered by created_at descending' do
      get uploaded_emails_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('jonh_doe@example.com', 'fulano@example.com')

      # ensure order: jonh_doe (newer) before fulano (older)
      body = response.body
      expect(body.index('jonh_doe@example.com')).to be < body.index('fulano@example.com')
    end
  end

  describe 'GET /uploaded_emails when there are no uploaded emails' do
    it 'responds successfully and shows the no records message' do
      get uploaded_emails_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Sem registros de upload de emails')
    end
  end

  describe 'GET /uploaded_emails/new' do
    it 'renders the upload form successfully' do
      get new_uploaded_email_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Importar novo email')
      expect(response.body).to include('Enviar e Processar')
    end
  end

  describe 'POST /uploaded_emails' do
    let(:valid_file) do
      fixture_file_upload(Rails.root.join('spec', 'fixtures', 'emails', 'email1.eml'), 'message/rfc822')
    end

    let(:invalid_file) do
      fixture_file_upload(Rails.root.join('spec', 'fixtures', 'emails', 'invalid.txt'), 'text/plain')
    end

    let(:invalid_content) do
      fixture_file_upload(Rails.root.join('spec', 'fixtures', 'emails', 'invalid.eml'), 'message/rfc822')
    end

    context 'when the uploaded file is valid' do
      it 'creates a new UploadedEmail and redirects to index with a notice' do
        expect {
          post uploaded_emails_path, params: { email_file: valid_file }
        }.to change(UploadedEmail, :count).by(1)

        expect(response).to redirect_to(uploaded_emails_path)
        follow_redirect!

        expect(response.body).to include('Arquivo enviado para a fila de processamento')
      end
    end

    context 'when the uploaded file is invalid with wrong extension' do
      it 'does not create record and redirects back with alert' do
        expect {
          post uploaded_emails_path, params: { email_file: invalid_file }
        }.not_to change(UploadedEmail, :count)

        expect(response).to redirect_to(new_uploaded_email_path)
        follow_redirect!

        expect(response.body).to include('O arquivo deve ser um email (.eml) valido')
      end
    end

    describe 'POST /uploaded_emails with unreadable .eml file' do
      it 'creates the record and logs an error when parsing fails' do
        # Force Mail.read to raise an exception so the rescue runs
        allow(Mail).to receive(:read).and_raise(StandardError, "broken email header")

        # Intercept the actual broadcast logger used by Rails
        broadcast_logger = Rails.logger
        expect(broadcast_logger).to receive(:error).with(/Falha ao ler cabecalho do e-email: broken email header/)

        expect {
          post uploaded_emails_path, params: { email_file: invalid_content }
        }.to change(UploadedEmail, :count).by(1)

        expect(response).to redirect_to(uploaded_emails_path)
        follow_redirect!
        expect(response.body).to include('Arquivo enviado para a fila de processamento')
      end
    end

    context 'when the uploaded file is invalid with wrong extension' do
      it 'does not create record and redirects back with alert' do
        expect {
          post uploaded_emails_path, params: { email_file: invalid_file }
        }.not_to change(UploadedEmail, :count)

        expect(response).to redirect_to(new_uploaded_email_path)
        follow_redirect!

        expect(response.body).to include('O arquivo deve ser um email (.eml) valido')
      end
    end

  end
end
