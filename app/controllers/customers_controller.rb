class CustomersController < ApplicationController
  def index
    @customers = Customer.select(:name, :email, :phone, :product_code).order(name: :desc)
  end
end
