# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

DECIDIM_VERSION = "~> 0.31.3"

gem "decidim", DECIDIM_VERSION
gem "decidim-ai", DECIDIM_VERSION
gem "decidim-collaborative_texts", DECIDIM_VERSION
# gem "decidim-conferences", DECIDIM_VERSION
# gem "decidim-demographics", DECIDIM_VERSION
gem "decidim-design", DECIDIM_VERSION
gem "decidim-elections", DECIDIM_VERSION
# gem "decidim-initiatives", DECIDIM_VERSION
gem "decidim-templates", DECIDIM_VERSION

gem "bootsnap", "~> 1.3"

gem "puma", ">= 6.3.1"

gem "omniauth-saml", "~> 2.2"

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri

  gem "brakeman", "~> 7.0"
  gem "decidim-dev", DECIDIM_VERSION
  gem "net-imap", "~> 0.5.0"
  gem "net-pop", "~> 0.1.1"
end

group :development do
  gem "letter_opener_web", "~> 2.0"
  gem "listen", "~> 3.1"
  gem "web-console", "~> 4.2"

  gem "capistrano", "~> 3.19"
  gem "capistrano-bundler"
  gem "capistrano-nvm"
  gem "capistrano-passenger"
  gem "capistrano-rails"
  gem "capistrano-rails-console"
  gem "capistrano-rbenv"
  gem "capistrano-sidekiq"
end

group :production do
  gem "appsignal"
  gem "dotenv-rails"
  gem "sidekiq", "~> 7.0"
  gem "whenever", require: false
end
