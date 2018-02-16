# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!


# get app/lib autoloading
Rails.application.eager_load! if ENV['RAILS_ENV'] == 'development'

# start price watcher
# PriceUpdateJob.perform_now