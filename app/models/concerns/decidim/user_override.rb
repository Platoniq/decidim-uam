# frozen_string_literal: true

module Decidim
  module UserOverride
    extend ActiveSupport::Concern

    UAM_STUDENT_MAIL = "@estudiante.uam.es"

    included do
      scope :students, -> { where("email LIKE ?", "%#{UAM_STUDENT_MAIL}") }
    end

    def student?
      email.ends_with?(UAM_STUDENT_MAIL)
    end
  end
end
