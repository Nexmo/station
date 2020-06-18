require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module NexmoDeveloper
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    Rails.autoloaders.main.ignore("#{Rails.root}/app/extensions")
    Rails.autoloaders.main.ignore("#{Rails.root}/app/admin")

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.middleware.use Rack::Deflater

    config.autoload_paths << "#{Rails.root}/app/constraints"
    config.autoload_paths << "#{Rails.root}/lib"
    config.autoload_paths += Dir[File.join(Rails.root, 'lib', 'open_api', '*.rb')].each { |l| require l }
    config.autoload_paths += Dir[File.join(Rails.root, 'lib', 'core_ext', '*.rb')].each { |l| require l }
    config.autoload_paths += Dir[File.join(Rails.root, 'app', 'extensions', '**', '*.rb')].each { |l| require l }
    config.autoload_paths += Dir[File.join(Rails.root, 'app', 'middleware', '**', '*.rb')].each { |l| require l }

    config.middleware.use NexmoDeveloper::BuildingBlockRedirect
    config.middleware.use NexmoDeveloper::VisitorId

    config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid
    end

    config.docs_base_path = ENV.fetch('DOCS_BASE_PATH', '.')
    config.middleware.use ::ActionDispatch::Static, "#{Rails.configuration.docs_base_path}/public", index: 'index'
    config.oas_path = ENV.fetch('OAS_PATH', './_open_api/api_specs/definitions')
    config.paths['app/views'].unshift("#{Rails.configuration.docs_base_path}/custom/views")
    config.i18n.load_path += Dir[Pathname.new(config.docs_base_path).join('config', 'locales', '**', '*.yml')]
  end
end
