require 'super_docopt'
require 'colsole'

module LoadRunner

  # Handles the command line interface
  class CommandLine < SuperDocopt::Base
    include Colsole

    version VERSION
    docopt File.expand_path 'docopt.txt', __dir__
    subcommands [{'send' => 'send_event'}, 'status', 'server']

    def send_event
      client = Client.new client_opts
      response = client.send_event args['EVENT'], payload_opts
      show response
    end

    def server
      Server.prepare port: args['--port'], bind: args['--bind']
      Server.run!
    end

    def status
      api = GitHubAPI.new
      opts = {
        state:       args['STATE'], 
        target_url:  args['--url'], 
        context:     args['--context'], 
        description: args['--desc']
      }

      response = api.status args['REPO'], args['SHA'], opts
      
      show response
    end

    private

    def client_opts
      {
        base_url: args['URL'], 
        secret_token: ENV['GITHUB_SECRET_TOKEN']
      }
    end

    # Convert command line arguments to a hash suitable for consumption
    # by Client#send. In essence, we are simply converting the input REF
    # argument, which can come in several forms, to a valid git ref.
    def payload_opts
      result = { repo: args['REPO'] }

      ref = args['REF']
      ref = "refs/tags/#{$1}" if ref =~ /^tag=(.+)/
      ref = "refs/heads/#{$1}" if ref =~ /^branch=(.+)/
      ref = "refs/heads/#{ref}" if ref !~ /^refs/

      result[:ref] = ref
      result
    end

    # Print the response json to stdout, and the response code to stderr.
    def show(response)
      puts JSON.pretty_generate(JSON.parse response.to_s)

      if response.respond_to? :code
        code = response.code.to_s
        color = code =~ /^2\d\d/ ? :txtgrn : :txtred
        say! "!#{color}!Response Code: #{code}"
      end
    end
  end
end
