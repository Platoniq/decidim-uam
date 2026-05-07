# frozen_string_literal: true

require "rails_helper"

describe Decidim::ProfileCell, type: :cell do
  subject { my_cell.call }

  controller Decidim::ProfilesController

  let(:organization) { create(:organization) }
  let(:user) { create(:user, :confirmed, organization:, email:) }
  let(:email) { "non-student@example.org" }
  let(:context) { { content_cell: "decidim/badges" } }
  let(:my_cell) { cell("decidim/profile", user, context:) }

  context "when the user is not a student" do
    it "does not show the student badge" do
      expect(subject).to have_no_xpath("//svg/use[contains(@href, 'ri-team-line')]")
    end
  end

  context "when the user is a student" do
    let(:email) { "alice@estudiante.uam.es" }

    it "shows the student badge with its label" do
      expect(subject).to have_xpath("//svg/use[contains(@href, 'ri-team-line')]")
      expect(subject).to have_css(".profile__details-badge", text: "Student")
    end

    context "and is also officialized" do
      let(:user) { create(:user, :officialized, organization:, email:) }

      it "shows both badges side-by-side" do
        expect(subject).to have_xpath("//svg/use[contains(@href, 'ri-star-s-fill')]")
        expect(subject).to have_xpath("//svg/use[contains(@href, 'ri-team-line')]")
      end
    end
  end
end
