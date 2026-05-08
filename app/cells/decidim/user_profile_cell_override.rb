# frozen_string_literal: true

module Decidim
  module UserProfileCellOverride
    extend ActiveSupport::Concern

    included do
      delegate :student?, to: :presented_resource
    end

    def student_badge_text
      I18n.t("decidim.profiles.show.student")
    end
  end
end
