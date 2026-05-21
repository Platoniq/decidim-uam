# frozen_string_literal: true

module Decidim
  module Uam
    module ContentBlocks
      class ProcessPhasesCell < Decidim::ContentBlocks::BaseCell
        include Decidim::ParticipatoryProcesses::ParticipatoryProcessHelper

        delegate :steps, :active_step, to: :resource

        def show
          return if steps.blank?

          render
        end
      end
    end
  end
end
