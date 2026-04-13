# frozen_string_literal: true

Rails.application.config.to_prepare do
  Decidim::OmniauthHelper.prepend(Decidim::OmniauthHelperDecorator)
end
