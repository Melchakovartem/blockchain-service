require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BlockchainService
  class Application < Rails::Application
  	config.active_job.queue_adapter = :sidekiq
  	config.cache_store = :redis_store, "redis://localhost:6379/cache", { expires_in: 90.minutes }
  end
end
