# frozen_string_literal: true

require "rails_helper"

# We make sure that the checksum of the file overridden is the same
# as the expected. If this test fails, it means that the overridden
# file should be updated to match any change/bug fix introduced in the core
checksums = [
  {
    package: "decidim-core",
    files: {
      # avoid CSRF issue with SAML
      "/app/controllers/decidim/devise/omniauth_registrations_controller.rb" => "cafb652eb07048c88a4c233e4fce77d5",
      # views
      "/app/views/layouts/decidim/footer/_mini.html.erb" => "c67cc97db27cdcf926f60682e399f688",
      # Tailwind config override (custom fonts)
      "/lib/decidim/assets/tailwind/tailwind.config.js.erb" => "1660c07ffa0dce33f5e6d20580c62d05"
    }
  },
  {
    package: "decidim-participatory_processes",
    files: {
      # source view for the custom process phases content block cell
      "/app/cells/decidim/participatory_processes/process_step/show.erb" => "93c7c8ea589de56c52b496d80271523b"
    }
  }
]

describe "Overridden files", type: :view do
  checksums.each do |item|
    spec = Gem::Specification.find_by_name(item[:package])
    item[:files].each do |file, signature|
      next unless spec

      it "#{spec.gem_dir}#{file} matches checksum" do
        expect(md5("#{spec.gem_dir}#{file}")).to eq(signature)
      end
    end
  end

  private

  def md5(file)
    Digest::MD5.hexdigest(File.read(file))
  end
end
