# frozen_string_literal: true

module Decidim
  module ProfileCellOverride
    extend ActiveSupport::Concern

    def show_student_badge?
      return false unless profile_holder.respond_to?(:student?)

      profile_holder.student?
    end

    def student_badge_text
      I18n.t("decidim.profiles.show.student")
    end

    private

    def show_badge?
      super || show_student_badge?
    end
  end
end
