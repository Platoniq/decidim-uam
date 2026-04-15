# frozen_string_literal: true

# config valid for current version and patch releases of Capistrano
lock "~> 3.19"

set :application, "decidim-uam"
set :repo_url, "git@github.com:Platoniq/decidim-uam.git"

# Default branch is :main
set :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/decidim/decidim-uam"

set :rbenv_type, :user
set :rbenv_ruby, File.read(".ruby-version").strip

set :nvm_type, :user
set :nvm_node, "v#{File.read(".node-version").strip}"
set :nvm_map_bins, %w(node npm)

SSHKit.config.command_map[:sidekiq] = "bundle exec sidekiq"
SSHKit.config.command_map[:sidekiqctl] = "bundle exec sidekiqctl"
set :sidekiq_roles, :worker
set :sidekiq_service_unit_user, :user

set :bundle_path, nil
set :bundle_without, nil
set :bundle_flags, nil

set :linked_files, ["config/master.key", ".rbenv-vars"]

set :linked_dirs, ["log", "tmp/pids", "tmp/cache", "tmp/sockets", "vendor/bundle", "public/system", "public/uploads", "storage", "node_modules", "public/decidim-packs"]

set :passenger_restart_command, "/usr/bin/passenger-config restart-app"

Rake::Task["deploy:assets:backup_manifest"].clear_actions
Rake::Task["deploy:assets:restore_manifest"].clear_actions

namespace :deploy do
  desc "Install npm dependencies before precompiling assets"
  task :npm_install do
    on roles(:web) do
      within release_path do
        execute :npm, "install"
      end
    end
  end

  before "deploy:assets:precompile", "deploy:npm_install"
end
