require 'rails_helper'

RSpec.describe "Uploaded Emails Index Page", type: :system do
  before do
    driven_by(:rack_test)
  end

  context 'when there are not customers' do
    it 'show the no records found message ' do
      visit uploaded_emails_path

      expect(page).to have_selector('h1', text: 'Importar Emails')
      expect(page).to have_text('Sem registros de upload de emails')
      expect(page).not_to have_selector('table')
    end
  end

  context 'when there are customers' do
    let!(:uploaded_emails) { create_list(:uploaded_email, 2) }

    it 'display them in the table' do
      visit uploaded_emails_path

      expect(page).to have_selector('table')
      uploaded_emails.each do |uploaded_email|
        expect(page).to have_text(uploaded_email.from)
        expect(page).to have_text(uploaded_email.to)
        expect(page).to have_text(uploaded_email.status)
      end
    end
  end
end
