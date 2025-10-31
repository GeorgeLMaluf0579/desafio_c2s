require 'rails_helper'
require 'mail'

RSpec.describe Parsers::FornecedorA do
  describe '#parse!' do
    context 'when the email is completed (email1.eml)' do
      let(:mail) do
        raw_email = File.read(Rails.root.join('spec', 'fixtures', 'emails', 'email1.eml'))
        Mail.read_from_string(raw_email)
      end

      subject(:parsed_data) { described_class.new(mail).parse! }

      it 'extract all data' do
        expect(parsed_data[:name]).to eq('João da Silva')
        expect(parsed_data[:email]).to eq('joao.silva@example.com')
        expect(parsed_data[:phone]).to eq('(11) 91234-5678')
        expect(parsed_data[:product_code]).to eq('ABC123')
        expect(parsed_data[:subject]).to eq('Pedido de orçamento - Produto ABC123')
      end
    end

    context 'when the email is completed but has a different layout (email2.eml)' do
      let(:mail) do
        raw_email = File.read(Rails.root.join('spec', 'fixtures', 'emails', 'email2.eml'))
        Mail.read_from_string(raw_email)
      end

      subject(:parsed_data) { described_class.new(mail).parse! }

      it 'extrai all data' do
        expect(parsed_data[:name]).to eq('Maria Oliveira')
        expect(parsed_data[:email]).to eq('maria.oliveira@example.com')
        expect(parsed_data[:phone]).to eq('21 99876-5432')
        expect(parsed_data[:product_code]).to eq('XYZ987')
        expect(parsed_data[:subject]).to eq('Interesse no produto XYZ987')
      end
    end

    context 'when the email has missing data (email3.eml)' do
      let(:mail) do
        raw_email = File.read(Rails.root.join('spec', 'fixtures', 'emails', 'email3.eml'))
        Mail.read_from_string(raw_email)
      end

      subject(:parsed_data) { described_class.new(mail).parse! }

      it 'extract the present data' do
        expect(parsed_data[:name]).to eq('Pedro Santos')
        expect(parsed_data[:email]).to eq('pedro.santos@example.com')
        expect(parsed_data[:product_code]).to eq('LMN456')
      end

      it 'return nil for missing data' do
        expect(parsed_data[:phone]).to be_nil
      end
    end
  end
end