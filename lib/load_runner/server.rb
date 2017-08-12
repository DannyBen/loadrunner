module LoadRunner

  # The Sinatra server
  class Server < ServerBase
    post '/payload' do
      request.body.rewind
      payload_body = request.body.read

      verify_signature payload_body if secret_token

      push = ActiveSupport::HashWithIndifferentAccess.new JSON.parse payload_body

      branch = push[:ref] =~ /refs\/heads/ ? push[:ref].sub('refs/heads/', '') : nil
      tag    = push[:ref] =~ /refs\/tags/ ? push[:ref].sub('refs/tags/', '') : nil
      repo   = push[:repository][:name]
      event  = request.env['HTTP_X_GITHUB_EVENT']

      result = { event: event, repo: repo, branch: branch, tag: tag }
      result.inspect

      file = "handlers/#{repo}/#{event}"
      File.exist?(file) ? `#{file}` : result.inspect
    end

    def verify_signature(payload_body)
      signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), secret_token, payload_body)
      signature_match = Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE'])
      return halt 401, "Bad Signature" unless signature_match
    end

    def secret_token
      ENV['GITHUB_SECRET_TOKEN']
    end
  end
end