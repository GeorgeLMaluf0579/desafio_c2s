require 'rails_helper'

RSpec.describe "home/index.html.erb", type: :view do
  it "displays 'Home' in an h1 tag" do
    render
    expect(rendered).to include("<h1>Home</h1>")
  end
end
