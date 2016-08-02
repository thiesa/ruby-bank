require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Bank
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.i18n.enforce_available_locales = true
    config.active_record.default_timezone = :utc

    config.generators do |generate|
      generate.helper true
      generate.javascript_engine false
      generate.request_specs true
      generate.routing_specs true
      generate.stylesheets true
      generate.test_framework :rspec
      generate.view_specs false
      generate.fixture_replacement :factory_girl
    end

    config.action_controller.action_on_unpermitted_parameters = :raise

    config.time_zone = 'Eastern Time (US & Canada)'
    config.autoload_paths << Rails.root.join('lib')

    # Needs to be false on Heroku
    config.public_file_server.enabled = false
    # config.static_cache_control = "public, max-age=31536000"

    # Add the fonts path
    config.assets.paths << Rails.root.join('app', 'assets', 'fonts', 'vendor')

    # Precompile additional assets
    config.assets.precompile += %w( *.svg *.eot *.woff *.ttf *.png *.jpg *.jpeg *.gif)
  end
end
