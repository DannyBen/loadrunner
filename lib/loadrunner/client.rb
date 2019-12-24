require 'httparty'
require 'uri'

module LoadRunner

  # Send simulated GitHub events to any webhook server
  class Client
    include HTTParty
    attr_accessor :secret_token, :host, :host_path, :payload, :encoding
    
    def initialize(opts={})
      @secret_token = opts[:secret_token]
      @encoding = opts[:encoding] || :json

      base_url = opts[:base_url] || 'http://localhost:3000/payload'
      base_url = "http://#{base_url}" unless base_url =~ /^http/

      url_parts = URI.parse base_url
      @host_path = url_parts.path
      url_parts.path = ''

      @host = url_parts.to_s

      self.class.base_uri host
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
      @payload = URI.encode_www_form(payload: @payload) if encoding == :form
      self.class.post host_path, body: @payload, headers: headers(event)
    end

  private

    def headers(event=:push)
      {}.tap do |header|
        header['X-GitHub-Event'] = event.to_s if event
        header['X-Hub-Signature'] = signature if secret_token
        header['Content-Type'] = content_type[encoding]
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

    def content_type
      {
        json: 'application/json',
        form: 'application/x-www-form-urlencoded',
      }
    end

  end
end