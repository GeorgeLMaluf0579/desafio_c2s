require 'rails_helper'

RSpec.describe Customer, type: :model do
  it 'has a valid factory' do
    customer = create(:customer)
    expect(customer).to be_valid
  end

  describe '#validations' do
    it 'email must be present' do
      customer = build(:customer, email: nil)
      expect(customer).to_not be_valid
    end

    it 'email must be unique' do
      customer1 = create(:customer, email: 'email@test.com')
      customer2 = build(:customer, email: 'email@test.com')
      expect(customer1).to be_valid
      expect(customer2).to_not be_valid
    end
  end
end
