# This file is used by Rack-based servers to start the application.
#ENV['RAILS_ENV'] = ENV['RACK_ENV']  if !ENV['RAILS_ENV'] && ENV['RACK_ENV']
ENV['RAILS_ENV'] = "production"
require ::File.expand_path('../config/environment',  __FILE__)
run NewsOnRails::Application

