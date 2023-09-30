require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BitsAndBites
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

    config.generators.after_generate do |files|
      parsable_files = files.filter { |file| file.end_with?('.rb') }
      unless parsable_files.empty?
        system("bundle exec rubocop -A --only Style/StringLiterals --fail-level=E #{parsable_files.shelljoin}", exception: true)
      end
    end

    # Always convert between snake_case and camelCase for our API
    excluded_routes = ->(env) { !env['PATH_INFO'].match(%r{^/api}) }
    config.middleware.use OliveBranch::Middleware,
                          inflection: 'camel',
                          exclude_params: excluded_routes,
                          exclude_response: excluded_routes
  end
end
