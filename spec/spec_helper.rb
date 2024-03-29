# Simplecov coverage reports
require 'simplecov'
SimpleCov.start

# Require the Gemfile
require 'rubygems'
require 'bundler'
Bundler.require :default, :development

# Sinatra testing with Rack::Test
require 'rack/test'
ENV['RACK_ENV'] = 'test'

# Include us
include Loadrunner

# Bootstrap Sinatra testing with rspec
module RSpecMixin
  include Rack::Test::Methods
  def app
    described_class.prepare
    described_class
  end
end

# Configure RSpec
RSpec.configure do |config|
  config.include RSpecMixin
  config.include ServerHelper
  config.include SignatureHelper
  config.example_status_persistence_file_path = 'spec/status.txt'
end
