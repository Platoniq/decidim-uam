# frozen_string_literal: true

require "rails_helper"

# We make sure that the checksum of the file overridden is the same
# as the expected. If this test fails, it means that the overridden
# file should be updated to match any change/bug fix introduced in the core
checksums = [
  {
    package: "decidim-core",
    files: {
      # cell views overridden to add the student badge
      "/app/cells/decidim/author/badge.erb" => "229d4ea78d53e181801b7d43f150da1f",
      "/app/cells/decidim/author_cell.rb" => "654c1ad4fc99765bba7901f891fe2040",
      "/app/cells/decidim/profile/badge.erb" => "2780148e5dc37ebbd30dd59f06587844",
      "/app/cells/decidim/profile_cell.rb" => "8596fc0dc050800fbb9fe38b59f1baf6",
      "/app/cells/decidim/user_profile/show.erb" => "c012fd9c5e5e7753f471660d92a6eb8e",
      "/app/cells/decidim/user_profile_cell.rb" => "0f20d006ccf4df77c59e3a2333a28a10",
      # avoid CSRF issue with SAML
      "/app/controllers/decidim/devise/omniauth_registrations_controller.rb" => "cafb652eb07048c88a4c233e4fce77d5",
      # extended with Decidim::UserOverride (students scope, student? predicate)
      "/app/models/decidim/user.rb" => "feff90d1d03a5f2b8f9686e98320f18a",
      # views
      "/app/views/layouts/decidim/footer/_mini.html.erb" => "c67cc97db27cdcf926f60682e399f688",
      # Tailwind config override (custom fonts)
      "/lib/decidim/assets/tailwind/tailwind.config.js.erb" => "1660c07ffa0dce33f5e6d20580c62d05"
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
