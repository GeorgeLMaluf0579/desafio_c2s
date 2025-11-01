require 'rails_helper'

RSpec.describe "Homes", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/"
      expect(response).to have_http_status(:success)
    end

    context "when there are customers and uploaded emails" do
      let!(:customer_a) { create(:customer) }
      let!(:customer_b) { create(:customer) }

      let!(:uploaded_email_success) { create(:uploaded_email, status: :success) }
      let!(:uploaded_email_fail)    { create(:uploaded_email, status: :fail) }

      it "renders the Home page and displays correct counters" do
        get root_path
        expect(response).to have_http_status(:ok)

        html = response.body

        expect(html).to include("<h1>Home</h1>")
        expect(html).to include("Clientes")
        expect(html).to include("Emails Importados")

        # Use regex that ignores spaces/newlines
        expect(html).to match(/<h5>\s*2\s*<\/h5>/)   # 2 customers
        expect(html).to match(/<h5>\s*2\s*<\/h5>/)   # 2 uploaded emails total
        expect(html).to match(/<h6[^>]*>\s*1\s*<\/h6>/)  # 1 success
        expect(html).to match(/<h6[^>]*>\s*1\s*<\/h6>/)  # 1 fail
      end
    end

    context "when there is no data" do
      it "renders successfully and shows zero counts" do
        get root_path
        expect(response).to have_http_status(:ok)

        html = response.body

        expect(html).to include("<h1>Home</h1>")
        expect(html).to include("Clientes")
        expect(html).to include("Emails Importados")

        # Expect 0 values somewhere in counts, allowing whitespace
        expect(html.scan(/>\s*0\s*</).size).to be >= 4
      end
    end
  end
end
