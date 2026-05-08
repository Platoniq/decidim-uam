# frozen_string_literal: true

Rails.application.config.to_prepare do
  Decidim::Devise::OmniauthRegistrationsController.include(Decidim::Devise::OmniauthRegistrationsControllerOverride)
  Decidim::User.include(Decidim::UserOverride)
  Decidim::AuthorCell.include(Decidim::AuthorCellOverride)
  Decidim::ProfileCell.prepend(Decidim::ProfileCellOverride)
  Decidim::UserProfileCell.include(Decidim::UserProfileCellOverride)
end
