require 'rails_helper'

RSpec.describe "EmailParserLogs", type: :request do
  describe "GET /email_parser_logs when there are logs" do
    let!(:older_log) { create(:email_parser_log, created_at: 2.days.ago) }
    let!(:newer_log) { create(:email_parser_log, created_at: 1.hour.ago) }

    it 'responds successfully and show email_parser_logs ordered by created_at descending' do
      get email_parser_logs_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(1.hour.ago.strftime("%d/%m/%Y %H:%M:%S"),
                                       2.days.ago.strftime("%d/%m/%Y %H:%M:%S"))

      body = response.body
      expect(body.index(1.hour.ago.strftime("%d/%m/%Y %H:%M:%S"))).to be < body.index(2.days.ago.strftime("%d/%m/%Y %H:%M:%S"))
    end
  end

  describe "GET /email_parser_logs when there are no logs" do
    it 'responds successfully and show the no records message' do
      get email_parser_logs_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Sem registro de logs')
    end
  end
end
