require 'rails_helper'

RSpec.describe "UploadedEmails", type: :request do
  describe 'GET /uploaded_emails when there are uploaded emails' do
    let!(:uploaded_email_a) { create(:uploaded_email, from: "fulano@example.com", to: "beltrano@example.com") }
    let!(:uploaded_email_b) { create(:uploaded_email, from: "jonh_doe@example.com", to: "jane_doe@example.com") }
    it 'responds successfully and show the uploaded emails ordered by created_at descending' do
      get uploaded_emails_path

      expect(response).to have_http_status(:ok)

      # expect(response.body).to include('Sem registros de upload de emails')
      expect(response.body).to include('jonh_doe@example.com', 'fulano@example.com')

      # Ensure descending order: jonh_doe (newer) appears before fulano (older)
      body = response.body
      expect(body.index('jonh_doe@example.com')).to be < body.index('fulano@example.com')
    end
  end

  describe 'GET /uploaded_emails when there are no customers' do
    it 'responds sucessfully and show no record found message' do
      get uploaded_emails_path

      expect(response).to have_http_status(:ok)

      # Check the body content instead of the template
      expect(response.body).to include('Sem registros de upload de emails')
    end
  end
end
