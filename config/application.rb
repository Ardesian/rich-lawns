require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Rich
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.secret_key_base = ENV["RICH_SECRET"]
    config.active_record.belongs_to_required_by_default = true
    config.assets.quiet = true
    config.assets.paths << Rails.root.join("app", "assets", "fonts")

    config.generators.javascript_engine = :js

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
