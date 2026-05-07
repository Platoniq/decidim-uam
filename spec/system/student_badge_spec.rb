# frozen_string_literal: true

require "rails_helper"

describe "Student badge" do
  let(:organization) { create(:organization) }
  let(:student) { create(:user, :confirmed, organization:, email: "alice@estudiante.uam.es") }
  let(:other_user) { create(:user, :confirmed, organization:, email: "bob@example.org") }

  before do
    switch_to_host(organization.host)
  end

  context "when visiting a student user profile" do
    before { visit decidim.profile_path(student.nickname) }

    it "shows the student badge with the team-line icon and label" do
      expect(page).to have_css(".profile__details-badge", text: "Student")
      expect(page).to have_css(".profile__details-badge svg use[href*='ri-team-line']", visible: :all)
    end
  end

  context "when visiting a non-student user profile" do
    before { visit decidim.profile_path(other_user.nickname) }

    it "does not render the student badge" do
      expect(page).to have_no_css(".profile__details-badge")
    end
  end

  context "when an officialized student appears in another user's following list" do
    let(:officialized_student) { create(:user, :confirmed, :officialized, organization:, email: "carol@estudiante.uam.es") }
    let(:follower) { create(:user, :confirmed, organization:) }

    before do
      create(:follow, user: follower, followable: officialized_student)
      visit decidim.profile_following_path(nickname: follower.nickname)
    end

    it "renders both avatar badges without one covering the other" do
      expect(page).to have_css(".profile__user-avatar-badge", count: 2)

      bounds = page.evaluate_script(<<~JS)
        Array.from(document.querySelectorAll('.profile__user-avatar-badge')).map((el) => {
          const r = el.getBoundingClientRect();
          return { left: r.left, right: r.right, top: r.top, bottom: r.bottom, width: r.width, height: r.height };
        });
      JS

      expect(bounds.length).to eq(2)
      bounds.each do |rect|
        expect(rect["width"]).to be > 0
        expect(rect["height"]).to be > 0
      end

      r1, r2 = bounds
      horizontally_disjoint = r1["right"] <= r2["left"] || r2["right"] <= r1["left"]
      vertically_disjoint = r1["bottom"] <= r2["top"] || r2["bottom"] <= r1["top"]
      expect(horizontally_disjoint || vertically_disjoint).to be(true),
                                                              "Expected the two avatar badges not to overlap, but their bounding rects intersect: #{r1.inspect} vs #{r2.inspect}"
    end
  end
end
