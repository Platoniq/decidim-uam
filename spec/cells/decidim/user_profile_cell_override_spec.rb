# frozen_string_literal: true

require "rails_helper"

describe Decidim::UserProfileCell, type: :cell do
  subject { my_cell.call }

  controller Decidim::PagesController

  let(:organization) { create(:organization) }
  let(:user) { create(:user, :confirmed, organization:, email:) }
  let(:email) { "non-student@example.org" }
  let(:my_cell) { cell("decidim/user_profile", user) }

  context "when the user is not a student" do
    it "does not render the student badge" do
      expect(subject).to have_no_xpath("//svg/use[contains(@href, 'ri-team-line')]")
    end
  end

  context "when the user is a student" do
    let(:email) { "alice@estudiante.uam.es" }

    it "renders the student avatar badge" do
      expect(subject).to have_css(".profile__user-avatar-badge")
      expect(subject).to have_xpath("//svg/use[contains(@href, 'ri-team-line')]")
    end

    it "exposes the badge label to screen readers" do
      expect(subject).to have_css(".profile__user-avatar-badge .sr-only", text: "Student")
    end

    context "and is also officialized" do
      let(:user) { create(:user, :officialized, organization:, email:) }

      it "renders both the officialized and student badges" do
        expect(subject).to have_xpath("//svg/use[contains(@href, 'ri-star-s-fill')]")
        expect(subject).to have_xpath("//svg/use[contains(@href, 'ri-team-line')]")
      end
    end
  end
end
