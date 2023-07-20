require 'super_docopt'
require 'colsole'
require 'loadrunner/client'
require 'loadrunner/server'
require 'loadrunner/status'
require 'loadrunner/version'

module Loadrunner
  # Handles the command line interface
  class CommandLine < SuperDocopt::Base
    include Colsole

    version VERSION
    docopt File.expand_path 'docopt.txt', __dir__
    subcommands [:event, :payload, :status, :server]

    def event
      client = Client.new client_opts
      response = client.send_event args['EVENT'], payload_opts
      show response
    end

    def payload
      client = Client.new client_opts
      file = args['FILE']
      raise ArgumentError, "File not found: #{file}" unless File.exist? file

      json = File.read file
      response = client.send_payload args['EVENT'], json
      show response
    end

    def server
      Server.prepare port: args['--port'], bind: args['--bind']
      Server.run!
    end

    def status
      response = Status.update repo: args['REPO'],
        sha: args['SHA'],
        state: args['STATE'],
        context: args['--context'],
        description: args['--desc'],
        url: args['--url']

      show response
    end

  private

    def client_opts
      {
        base_url:     args['URL'],
        secret_token: ENV['GITHUB_SECRET_TOKEN'],
        encoding:     args['--form'] ? :form : :json
      }
    end

    # Convert command line arguments to a hash suitable for consumption
    # by Client#send. In essence, we are simply converting the input REF
    # argument, which can come in several forms, to a valid git ref.
    def payload_opts
      result = { repo: args['REPO'] }

      ref = args['REF'] || 'master'
      ref = "refs/tags/#{$1}" if ref =~ /^tag=(.+)/
      ref = "refs/heads/#{$1}" if ref =~ /^branch=(.+)/
      ref = "refs/heads/#{ref}" if ref !~ /^refs/

      result[:ref] = ref
      result
    end

    # Print the response json to stdout, and the response code to stderr.
    def show(response)
      puts json_generate(response)

      if response.respond_to? :code
        code = response.code.to_s
        color = code =~ /^2\d\d/ ? :g : :r
        say "#{color}`Response Code: #{code}`"
      end
    end

    def json_generate(object)
      JSON.pretty_generate(JSON.parse object.to_s)
    rescue
      object.to_s
    end
  end
end
