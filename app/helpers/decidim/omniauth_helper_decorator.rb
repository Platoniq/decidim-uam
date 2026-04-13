# frozen_string_literal: true

# Adjusts the cosmetic provider name for the UAM SAML provider so the login
# button reads "UAM" (uppercase) instead of the auto-titleized "Uam".
module Decidim
  module OmniauthHelperDecorator
    def normalize_provider_name(provider)
      return "UAM" if provider == :uam

      super
    end

    def provider_name(provider)
      return "UAM" if provider == :uam

      super
    end
  end
end
