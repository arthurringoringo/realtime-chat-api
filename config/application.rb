require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RealtimeChatApi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.hosts = [
      IPAddr.new("0.0.0.0/0"),        # All IPv4 addresses.
      IPAddr.new("::/0"),             # All IPv6 addresses.
      "localhost",
      "dev-dms.arthurringo.com",
      "chat-api.arthurringo.com",
      "arthurringo.com",
      "www.example.com"
    ]
    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
    config.generators.test_framework :rspec
  end
end
