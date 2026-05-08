# frozen_string_literal: true

module Decidim
  module AuthorCellOverride
    extend ActiveSupport::Concern

    def show_student_badge?
      return false unless model.respond_to?(:student?)

      model.student?
    end

    def student_badge_text
      I18n.t("decidim.profiles.show.student")
    end
  end
end
