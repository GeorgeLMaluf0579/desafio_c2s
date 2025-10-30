require 'rails_helper'

RSpec.describe "Customer Index Page", type: :system do
  before do
    driven_by(:rack_test)
  end

  context 'when there are not customers' do
    it 'show the no records found message ' do
      visit customers_path

      expect(page).to have_selector('h1', text: 'Clientes importados')
      expect(page).to have_text('Sem registro de clientes')
      expect(page).not_to have_selector('table')
    end
  end

  context 'when there are customers' do
    let!(:customers) { create_list(:customer, 2) }

    it 'display them in the table' do
      visit customers_path

      expect(page).to have_selector('table')
      customers.each do |customer|
        expect(page).to have_text(customer.name)
        expect(page).to have_text(customer.email)
        expect(page).to have_text(customer.phone)
        expect(page).to have_text(customer.product_code)
      end
    end
  end
end
