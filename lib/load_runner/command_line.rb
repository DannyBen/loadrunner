require 'singleton'
require 'docopt'

module LoadRunner

  # Handles the command line interface
  class CommandLine
    include Singleton

    attr_reader :args

    # Gets an array of arguments (e.g. ARGV), executes the command if valid
    # and shows usage patterns / help otherwise.
    def execute(argv=[])
      doc = File.read File.dirname(__FILE__) + '/docopt.txt'
      begin
        @args = Docopt::docopt(doc, argv: argv, version: VERSION)
        handle
      rescue Docopt::Exit => e
        puts e.message
      end
    end

    private

    # Called when the arguments match one of the usage patterns. Will 
    # delegate action to other, more specialized methods.
    def handle
      return send   if args['send']
      return server if args['server']
    end

    def send
      client = Client.new client_opts
      response = client.send args['EVENT'], payload_opts
      puts response
    end

    def server
      Server.prepare port: args['--port'], bind: args['--bind']
      Server.run!
    end

    def client_opts
      {
        base_url: args['URL'], 
        secret_token: '123'
      }
    end

    def payload_opts
      result = { repo: args['REPO'] }

      ref = args['REF']
      ref = "refs/tags/#{$1}" if ref =~ /^tag=(.+)/
      ref = "refs/heads/#{$1}" if ref =~ /^branch=(.+)/
      ref = "refs/heads/#{ref}" if ref !~ /^refs/

      result[:ref] = ref
      result
    end
  end
end
