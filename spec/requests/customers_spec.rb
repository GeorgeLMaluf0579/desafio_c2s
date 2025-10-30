require 'rails_helper'

RSpec.describe 'Customers', type: :request do
  describe 'GET /customers when there are customers' do
    let!(:customer_a) { create(:customer, name: 'Alice', email: 'alice@example.com', phone: '111', product_code: 'P01') }
    let!(:customer_b) { create(:customer, name: 'Bob', email: 'bob@example.com', phone: '222', product_code: 'P02') }

    it 'responds successfully and shows customers ordered by name ascending' do
      get customers_path

      expect(response).to have_http_status(:ok)

      # Check the body content instead of the template
      expect(response.body).to include('Alice', 'Bob')

      # Ensure ascending order (Alice before Bob)
      body = response.body
      expect(body.index('Bob')).to be > body.index('Alice')
    end
  end

  describe 'GET /customers when there are no customers' do
    it 'responds successfully and shows no record found message' do
      get customers_path

      expect(response).to have_http_status(:ok)

      # Check the body content instead of the template
      expect(response.body).to include('Sem registro de clientes')
    end
  end
end
