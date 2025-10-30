require 'rails_helper'

RSpec.describe 'Home Index Page', type: :system do
  it 'show the Home index page heading' do
    visit root_path
    expect(page).to have_content('Home')
  end
end