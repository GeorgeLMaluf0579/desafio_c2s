require 'rails_helper'
require 'mail'

RSpec.describe Parsers::ParceiroB do
  describe '#parse!' do
    context 'when the email is completed (email4.eml)' do
      let(:mail) do
        raw_email = File.read(Rails.root.join('spec', 'fixtures', 'emails', 'email4.eml'))
        Mail.read_from_string(raw_email)
      end

      subject(:parsed_data) { described_class.new(mail).parse! }

      it 'extract all the data' do
        expect(parsed_data[:name]).to eq('Ana Costa')
        expect(parsed_data[:email]).to eq('ana.costa@example.com')
        expect(parsed_data[:phone]).to eq('+55 31 97777-1111')
        expect(parsed_data[:product_code]).to eq('PROD-555')
        expect(parsed_data[:subject]).to eq('Cliente interessado no PROD-555')
      end
    end

    context 'when the email has a different layout (email5.eml)' do
      let(:mail) do
        raw_email = File.read(Rails.root.join('spec', 'fixtures', 'emails', 'email5.eml'))
        Mail.read_from_string(raw_email)
      end

      subject(:parsed_data) { described_class.new(mail).parse! }

      it 'extract all the data' do
        expect(parsed_data[:name]).to eq('Ricardo Almeida')
        expect(parsed_data[:email]).to eq('ricardo.almeida@example.com')
        expect(parsed_data[:phone]).to eq('41 98888-2222')
        expect(parsed_data[:product_code]).to eq('PROD-888')
      end
    end

    context 'when the email has missing data (email6.eml)' do
      let(:mail) do
        raw_email = File.read(Rails.root.join('spec','fixtures', 'emails', 'email6.eml'))
        Mail.read_from_string(raw_email)
      end

      subject(:parsed_data) { described_class.new(mail).parse! }

      it 'extract the present data' do
        expect(parsed_data[:name]).to eq('Fernanda Lima')
        expect(parsed_data[:phone]).to eq('61 93333-4444')
        expect(parsed_data[:product_code]).to eq('PROD-999')
      end

      it 'return nil for missing data' do
        expect(parsed_data[:email]).to be_nil
      end
    end
  end
end