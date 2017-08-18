require 'httparty'

module LoadRunner
  # Communicate with GitHub
  class GitHubAPI
    include HTTParty
    
    base_uri 'https://api.github.com'

    # Send status update to a pull request. Supported options:
    # * +state+: :pending, :success, :failure or :error
    # * +context+: any string
    # * +description+: any string
    # * +target_url+: any valid URL
    def status(sha, opts={})
      # sha = '018b0ac55dbf0d8e1eef6df46e04dfef8bea9b96'
      message = {
        body: {
          state: (opts[:state] ? opts[:state].to_s : 'pending'),
          context: (opts[:context] || 'LoadRunner'),
          description: opts[:description],
          target_url: opts[:target_url]
        }.to_json
      }
      self.class.post "/repos/dannyben/experiments/statuses/#{sha}", message.merge(request_options)
    end

    private

    def request_options
      {
        headers: headers 
      }
    end

    def headers
      {
        "Authorization": "token #{secret_token}",
        "User-Agent":    "LoadRunner"
      }
    end

    def secret_token
      ENV['GITHUB_ACCESS_TOKEN']
    end

  end
end
