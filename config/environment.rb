# -*- encoding : utf-8 -*-
  # Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
NewsOnRails::Application.initialize!

#AUTHORIZATION_MIXIN = "object roles"

#require File.join(File.dirname(__FILE__), 'boot')
#gem "calendar_date_select"

#gem 'actionmailer'
#require_gem 'rails-1.1.6'
#require_gem 'activesupport-1.3.1'
#require_gem 'activerecord-1.14.4'
#require_gem 'actionpack-1.12.5'
#require_gem 'actionmailer-1.2.5'
#require_gem 'actionwebservice-1.1.6'


#Rails::Initializer.run do |config|
#  config.action_mailer.delivery_method = :sendmail
#  config.action_mailer.perform_deliveries = true
#  config.action_mailer.default_charset = "iso8859-1"
#
##  config.gem 'mislav-will_paginate', :version => '~> 2.2.3', :lib => 'will_paginate',
##    :source => 'http://gems.github.com'
#
#  # Settings in config/environments/* take precedence those specified here
#
#  # Skip frameworks you're not going to use
#  #config.frameworks -= [ :action_web_service, :action_mailer ]
#
#  # Add additional load paths for your own custom dirs
#  # config.load_paths += %W( #{RAILS_ROOT}/extras )
#
#  # Force all environments to use the same logger level
#  # (by default production uses :info, the others :debug)
#  # config.log_level = :debug
#
#  # Use the database for sessions instead of the file system
#  # (create the session table with 'rake create_sessions_table')
#  # config.action_controller.session_store = :active_record_store
#
#  # Enable page/fragment caching by setting a file-based store
#  # (remember to create the caching directory and make it readable to the application)
#  #config.action_controller.fragment_cache_store = :file_store, "#{RAILS_ROOT}/cache"
#  #ActionController::Base.perform_caching = true
#  #ActionController::Base.page_cache_directory = "#{RAILS_ROOT}/www-public"
#
#  # Activate observers that should always be running
#  # config.active_record.observers = :cacher, :garbage_collector
#
#  # Make Active Record use UTC-base instead of local time
#  # config.active_record.default_timezone = :utc
#
#  # Use Active Record's schema dumper instead of SQL when creating the test database
#  # (enables use of different database adapters for development and test environments)
#  # config.active_record.schema_format = :ruby
#
#  # See Rails::Configuration for more options
#
#  config.active_record.observers = :noruser_observer
#  config.action_controller.session = { :session_key => "_myapp_session", :secret => "sfoie 938sbile asidf39sd v39sad 39sf  l9se9v 9sv939v das3cbrhhf2ksdj" }
#end

# Add new inflection rules using the following format
# (all these examples are active by default):
# Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

# Include your application configuration below
#  module LoginEngine
#    config :salt, "Maste23vo"
#    config :use_email_notification, false
#  end
#
# module UserEngine
#   config :admin_login, "admin"
#   config :admin_email, "henrik@motrasisme.no"
#   config :admin_password, "sos rasisme"
# end

# Engines.create_logger(File.open("#{RAILS_ROOT}/log/engines_debug.log", 'w'))
# Engines.start :login, :user #, :tableau
# UserEngine.check_system_roles

#require 'rexml-expansion-fix' # Sikkerhesfiks.
require 'will_paginate'
#config.gem "acts_as_versioned"

#gem "calendar_date_select"
