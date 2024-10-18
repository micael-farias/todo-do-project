# config/initializers/sidekiq.rb
require 'sidekiq'
require 'sidekiq-cron' # Necessário se estiver usando sidekiq-cron

Sidekiq.configure_server do |config|
    config.redis = { url: ENV['REDIS_URL'] || 'redis://localhost:6379/0' }
  
    # Carregar os jobs do sidekiq-cron
    schedule_file = "config/sidekiq.yml"
  
    if File.exist?(schedule_file) && Sidekiq.server?
        config = YAML.load_file(schedule_file)
        Rails.logger.info config
        if config['schedule']
          Sidekiq::Cron::Job.load_from_hash!(config['schedule'])
        end
      end
    end
  
Sidekiq.configure_client do |config|
   config.redis = { url: ENV['REDIS_URL'] || 'redis://localhost:6379/0' }
end
  