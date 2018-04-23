require 'httparty'

module LoadRunner

  # Send simulated GitHub events to any webhook server
  class Client
    include HTTParty
    attr_accessor :secret_token, :base_url, :payload
    
    def initialize(opts={})
      @secret_token = opts[:secret_token]
      @base_url = opts[:base_url] || 'localhost:3000/payload'
      self.class.base_uri base_url
    end

    # Send a simulated event using a shorthand syntax. opts can contain
    # any of these:
    # * +repo+: repository name
    # * +ref+: ref ID (for example +ref/heads/branchname+)
    # * +branch+: branch name
    # * +tag+: tag name
    def send_event(event=:push, opts={})
      payload = build_payload opts
      send_payload event, payload
    end

    # Send a simulated event. Payload can be a hash or a JSON string.
    def send_payload(event, payload)
      @payload = payload.is_a?(String) ? payload : payload.to_json
      headers = headers event
      self.class.post "", body: @payload, headers: headers
    end

    private

    def headers(event=:push)
      {}.tap do |header|
        header['X_GITHUB_EVENT'] = event.to_s if event
        header['X_HUB_SIGNATURE'] = signature if secret_token
      end
    end

    def signature
      return nil unless secret_token
      'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), secret_token, payload)
    end

    def build_payload(opts={})
      {}.tap do |result|
        result[:ref] = ref_from_opts opts
        result[:repository] = repo_from_opts opts
      end
    end

    def ref_from_opts(opts)
      if opts[:ref]
        opts[:ref]
      elsif opts[:branch]
        "refs/heads/#{opts[:branch]}" 
      elsif opts[:tag]
        "refs/tags/#{opts[:tag]}"
      end
    end

    def repo_from_opts(opts)
      if opts[:repo] =~ /.+\/.+/
        _owner, name = opts[:repo].split '/'
        { name: name, full_name: opts[:repo] }
      else 
        { name: opts[:repo] }
      end
    end

  end
end