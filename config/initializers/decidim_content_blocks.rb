# frozen_string_literal: true

Rails.application.config.to_prepare do
  Decidim.content_blocks.register(:participatory_process_homepage, :process_phases) do |content_block|
    content_block.cell = "decidim/uam/content_blocks/process_phases"
    content_block.public_name_key = "decidim.uam.content_blocks.process_phases.name"
  end
end
