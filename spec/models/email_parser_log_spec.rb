require 'rails_helper'

RSpec.describe EmailParserLog, type: :model do
  let(:uploaded_email) { create(:uploaded_email) }

  describe 'associations' do
    it 'belongs to uploaded_email' do
      log = described_class.create(uploaded_email: uploaded_email, level: "INFO", extracted_data: "{}")
      expect(log.uploaded_email).to eq(uploaded_email)
    end
  end

  describe 'enums' do
    it 'defines correct enum mappings' do
      expect(described_class.levels).to eq(
        "error" => "ERROR",
        "info" => "INFO",
        "warning" => "WARN"
      )
    end
  end

  describe 'valid factory' do
    it 'is valid with default attributes' do
      log = build(:email_parser_log, uploaded_email: uploaded_email)
      expect(log).to be_valid
    end

    it 'is valid for each log level' do
      %i[error_level info_level warning_level].each do |trait|
        log = build(:email_parser_log, trait, uploaded_email: uploaded_email)
        expect(log).to be_valid
        expect(log.level).to eq(trait.to_s.sub('_level', ''))
      end
    end
  end

  describe 'data integrity' do
    it 'stores JSON in extracted_data' do
      data = { key: 'value' }.to_json
      log = described_class.create(uploaded_email: uploaded_email, level: "INFO", extracted_data: data)
      expect(JSON.parse(log.extracted_data)).to include("key" => "value")
    end

    it 'has a proper error message for error level' do
      log = build(:email_parser_log, :error_level, uploaded_email: uploaded_email)
      expect(log.error_message).to match(/error level/i)
    end
  end
end
