module Loadrunner

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
      payload = JSON.parse json_string

      opts = {}
      opts[:repo]    = payload.dig('repository', 'name')
      opts[:event]   = request.env['HTTP_X_GITHUB_EVENT']
      opts[:ref]     = payload['ref']
      opts[:branch]  = payload['ref'] =~ /refs\/heads/ ? payload['ref'].sub('refs/heads/', '') : nil
      opts[:tag]     = payload['ref'] =~ /refs\/tags/ ? payload['ref'].sub('refs/tags/', '') : nil
      opts[:payload] = json_string

      runner = Runner.new opts
      success = runner.execute

      status 404 unless success

      json runner.response
    end
  end
end