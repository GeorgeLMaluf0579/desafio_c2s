require 'rails_helper'

RSpec.describe UploadedEmail, type: :model do
  it 'has a valid factory' do
    uploaded_email = create(:uploaded_email)
    expect(uploaded_email).to be_valid
  end

  describe '#validations' do
    it 'is invalid with an unknown status' do
      uploaded_email = build(:uploaded_email, status: :none)
      expect(uploaded_email).not_to be_valid
      expect(uploaded_email.errors[:status]).to be_present
    end
  end
end
