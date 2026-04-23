# frozen_string_literal: true

# The UAM SAML Identity Provider posts the `SAMLResponse` back to our ACS URL
# (HTTP-POST binding). That request has no Rails CSRF token, so Decidim's
# application-wide `protect_from_forgery with: :exception` blocks it with a
# 422. The SAML signature validation performed by omniauth-saml replaces CSRF
# protection for this endpoint, so skipping the Rails check here is safe.
module Decidim
  module Devise
    module OmniauthRegistrationsControllerOverride
      extend ActiveSupport::Concern

      included do
        skip_before_action :verify_authenticity_token, only: :uam, raise: false
      end
    end
  end
end
