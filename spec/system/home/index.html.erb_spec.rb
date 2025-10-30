require 'rails_helper'

RSpec.describe 'Home Page', type: :system do
  it 'show the Home page heading' do
    visit root_path
    expect(page).to have_content('Home')
  end
end