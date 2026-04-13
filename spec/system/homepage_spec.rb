# frozen_string_literal: true

require "rails_helper"
describe "Homepage" do
  include_context "when visiting organization homepage"

  it "shows the homepage" do
    expect(page).to have_content("Decidim")
  end
end
