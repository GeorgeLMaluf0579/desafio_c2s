require 'rails_helper'

RSpec.describe EmailProcessorService do
  let!(:email_fornecedor_a) { create(:uploaded_email, :with_full_fornecedor_a) }
  let!(:email_fornecedor_b) { create(:uploaded_email, :with_full_parceiro_b) }
  let!(:email_inconsistente) { create(:uploaded_email, :without_email_contact) }
  let!(:email_desconhecido) { create(:uploaded_email, :with_unknow_sender) }
  subject(:service) { described_class.new(email_fornecedor_a) }

  describe '#process' do
    context 'when the process run successfully' do
      it 'create a new customer on database' do
        expect{
          described_class.new(email_fornecedor_a).process
        }.to change(Customer, :count).by(1)
      end

      it 'create a info log with success message' do
        expect{
          described_class.new(email_fornecedor_b).process
        }.to change{EmailParserLog.where(level: :info).count}.by(1)
      end

      it 'link the log with the uploaded email' do
        described_class.new(email_fornecedor_a).process
        log = EmailParserLog.last
        expect(log.uploaded_email).to eq(email_fornecedor_a)
      end
    end

    context 'when the process failed' do
      it 'do not create a customer if contact data is missing' do
        expect {
          described_class.new(email_inconsistente).process
        }.not_to change(Customer, :count)
      end

      it 'create a error level log with error message' do
        expect {
          described_class.new(email_inconsistente).process
        }.to change { EmailParserLog.where(level: :error).count }.by(1)
      end

      it 'create a error level log if the email missing the sender' do
        expect {
          described_class.new(email_desconhecido).process
      }.to change { EmailParserLog.where(level: :error).count }.by(1)
      end
    end
  end
end