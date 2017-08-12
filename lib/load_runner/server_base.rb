require 'sinatra/base'
require "sinatra/reloader"
require 'active_support/core_ext/hash/indifferent_access'

module LoadRunner

  # The base class for the sinatra server.
  # Initialize what we can here, but since there are values that will
  # become known only later, the #prepare method is provided.
  class ServerBase < Sinatra::Application
    set :root, File.expand_path('../../', __dir__)
    set :server, :puma

    configure :development do
      register Sinatra::Reloader if defined? Sinatra::Reloader
    end

    # Since we cannot use any config values in the main body of the class,
    # since they will be updated later, we need to set anything that relys
    # on the config values just before running the server.
    # The CommandLine class and the test suite should both call
    # `Server.prepare` before calling Server.run!
    def self.prepare(opts={})
      set :bind, opts[:bind] || '0.0.0.0'
      set :port, opts[:port] || '3000'
    end
  end

end
