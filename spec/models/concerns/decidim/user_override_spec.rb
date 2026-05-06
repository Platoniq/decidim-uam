# frozen_string_literal: true

require "rails_helper"

describe Decidim::UserOverride do
  let(:organization) { create(:organization) }
  let!(:student) { create(:user, organization:, email: "alice@estudiante.uam.es") }
  let!(:other_student) { create(:user, organization:, email: "bob@estudiante.uam.es") }
  let!(:staff) { create(:user, organization:, email: "carol@uam.es") }

  describe "students" do
    it "returns only users with a student email" do
      expect(Decidim::User.students).to contain_exactly(student, other_student)
    end
  end

  describe "student?" do
    it "is true for student emails" do
      expect(student.student?).to be true
    end

    it "is false for non-student emails" do
      expect(staff.student?).to be false
    end
  end
end
