# frozen_string_literal: true

# Registers the SAML 2.0 identity provider of the Universidad Autónoma de Madrid
# (UAM) as a Decidim OmniAuth provider.
#
# All configuration is read from environment variables via Decidim::Env so it
# stays consistent with the rest of the Decidim configuration (no secrets.yml,
# no encrypted credentials).
#
# The provider is registered under the key `:uam` so the OmniAuth callback URL
# is `/users/auth/uam/callback` and the Service Provider metadata XML is
# exposed at `/users/auth/uam/metadata` (this is the file UAM IT needs in order
# to register us in their Identity Provider).

if Decidim::Env.new("OMNIAUTH_UAM_ENABLED").to_boolean_string == "true"
  idp_metadata_url = Decidim::Env.new("OMNIAUTH_UAM_IDP_METADATA_URL").to_s
  idp_metadata_file = Decidim::Env.new("OMNIAUTH_UAM_IDP_METADATA_FILE").to_s

  uam_settings = {
    enabled: true,
    icon_path: Decidim::Env.new("OMNIAUTH_UAM_SP_ENTITY_ID", "media/images/uam.svg").to_s,
    sp_entity_id: Decidim::Env.new("OMNIAUTH_UAM_SP_ENTITY_ID").to_s,
    assertion_consumer_service_url: Decidim::Env.new("OMNIAUTH_UAM_ACS_URL").to_s,
    certificate: Decidim::Env.new("OMNIAUTH_UAM_SP_CERTIFICATE").to_s,
    private_key: Decidim::Env.new("OMNIAUTH_UAM_SP_PRIVATE_KEY").to_s,
    name_identifier_format: Decidim::Env.new(
      "OMNIAUTH_UAM_NAME_IDENTIFIER_FORMAT",
      "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"
    ).to_s,
    attr_uid: Decidim::Env.new("OMNIAUTH_UAM_ATTR_UID", "uid").to_s,
    attr_email: Decidim::Env.new("OMNIAUTH_UAM_ATTR_EMAIL", "mail").to_s,
    attr_name: Decidim::Env.new("OMNIAUTH_UAM_ATTR_NAME", "givenName").to_s,
    attr_surname: Decidim::Env.new("OMNIAUTH_UAM_ATTR_SURNAME", "sn").to_s,
    attr_displayname: Decidim::Env.new("OMNIAUTH_UAM_ATTR_DISPLAYNAME", "displayName").to_s
  }

  # Make the provider visible to Decidim (button in the login screen, etc.).
  # We merge into the existing default providers instead of replacing them, so
  # Decidim's built-in providers (developer, facebook, google, twitter) keep
  # working when their env vars are present.
  Decidim.omniauth_providers = Decidim.omniauth_providers.merge(uam: uam_settings)

  # Parse the IdP metadata once at boot. If unreachable we log and skip
  # registering the OmniAuth strategy: Decidim will still boot, but the UAM
  # button will not work until the IdP metadata is reachable again.
  idp_settings =
    begin
      require "onelogin/ruby-saml/idp_metadata_parser"
      parser = OneLogin::RubySaml::IdpMetadataParser.new
      if idp_metadata_file.present?
        parser.parse_to_hash(File.read(idp_metadata_file))
      elsif idp_metadata_url.present?
        parser.parse_remote_to_hash(idp_metadata_url)
      end
    rescue StandardError => e
      Rails.logger.warn("[OmniAuth UAM] Could not load IdP metadata: #{e.class}: #{e.message}")
      nil
    end

  if idp_settings.present?
    Rails.application.config.middleware.use OmniAuth::Builder do
      provider(
        :saml,
        # Use a custom name so the route, button and translations are scoped
        # to UAM rather than the generic SAML strategy.
        name: :uam,
        issuer: uam_settings[:sp_entity_id],
        sp_entity_id: uam_settings[:sp_entity_id],
        assertion_consumer_service_url: uam_settings[:assertion_consumer_service_url],
        certificate: uam_settings[:certificate],
        private_key: uam_settings[:private_key],
        name_identifier_format: uam_settings[:name_identifier_format],
        # uid is taken from this SAML attribute — fallback to NameID if absent.
        uid_attribute: uam_settings[:attr_uid],
        # Map UAM attribute names → OmniAuth `info` hash keys used by Decidim.
        # The list is tried left-to-right, the first present attribute wins.
        attribute_statements: {
          name: [uam_settings[:attr_displayname], uam_settings[:attr_name]],
          first_name: [uam_settings[:attr_name]],
          last_name: [uam_settings[:attr_surname]],
          email: [uam_settings[:attr_email]],
          nickname: [uam_settings[:attr_uid]]
        },
        # Declared in the SP metadata XML so UAM IT knows what we expect.
        request_attributes: [
          { name: uam_settings[:attr_uid], friendly_name: "User ID", is_required: true },
          { name: uam_settings[:attr_email], friendly_name: "Email", is_required: true },
          { name: uam_settings[:attr_name], friendly_name: "First name", is_required: false },
          { name: uam_settings[:attr_surname], friendly_name: "Surname", is_required: false }
        ],
        security: {
          authn_requests_signed: uam_settings[:private_key].present?,
          want_assertions_signed: true,
          want_assertions_encrypted: false,
          embed_sign: false,
          digest_method: "http://www.w3.org/2001/04/xmlenc#sha256",
          signature_method: "http://www.w3.org/2001/04/xmldsig-more#rsa-sha256"
        }.merge(idp_settings.slice(:idp_cert, :idp_cert_fingerprint, :idp_cert_fingerprint_algorithm)).compact,
        idp_sso_service_url: idp_settings[:idp_sso_service_url] || idp_settings[:idp_sso_target_url],
        idp_slo_service_url: idp_settings[:idp_slo_service_url] || idp_settings[:idp_slo_target_url],
        idp_cert: idp_settings[:idp_cert],
        idp_cert_fingerprint: idp_settings[:idp_cert_fingerprint],
        idp_cert_fingerprint_algorithm: idp_settings[:idp_cert_fingerprint_algorithm]
      )
    end
  end
end
