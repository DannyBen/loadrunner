module LoadRunner

  # The Sinatra server
  class Server < ServerBase
    include ServerHelper
    include SignatureHelper

    get '/' do
      "OK"
    end

    post '/payload' do
      request.body.rewind
      payload_body = request.body.read

      signature = request.env['HTTP_X_HUB_SIGNATURE']
      state = verify_signature payload_body, signature

      halt 401, halt_messages[state] if state != :ok

      if request.content_type == 'application/json'
        json_string = payload_body
      else
        json_string = URI.decode_www_form(payload_body).to_h["payload"]
      end
      payload = ActiveSupport::HashWithIndifferentAccess.new JSON.parse json_string

      opts = {}
      opts[:repo]    = payload.dig(:repository, :name)
      opts[:event]   = request.env['HTTP_X_GITHUB_EVENT']
      opts[:branch]  = payload[:ref].sub('refs/heads/', '') if payload[:ref] =~ /refs\/heads/
      opts[:tag]     = payload[:ref].sub('refs/tags/', '') if payload[:ref] =~ /refs\/tags/
      opts[:payload] = json_string

      runner = Runner.new opts
      success = runner.execute

      status 404 unless success

      json runner.response
    end
  end
end