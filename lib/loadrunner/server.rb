require 'loadrunner/server_helper'
require 'loadrunner/server_base'
require 'loadrunner/signature_helper'
require 'loadrunner/runner'

module Loadrunner
  # The Sinatra server
  class Server < ServerBase
    include ServerHelper
    include SignatureHelper

    get '/' do
      'loadrunner ready'
    end

    post '/' do
      request.body.rewind
      payload_body = request.body.read

      signature = request.env['HTTP_X_HUB_SIGNATURE']
      state = verify_signature payload_body, signature

      halt 401, halt_messages[state] if state != :ok

      if request.content_type == 'application/json'
        json_string = payload_body
      else
        json_string = URI.decode_www_form(payload_body).to_h['payload']
      end
      payload = JSON.parse json_string

      opts = {}
      opts[:repo]    = payload.dig('repository', 'name')
      opts[:owner]   = payload.dig('repository', 'owner', 'name')
      opts[:commit]  = payload['after']
      opts[:event]   = request.env['HTTP_X_GITHUB_EVENT']
      opts[:ref]     = payload['ref']
      opts[:branch]  = payload['ref'] =~ /refs\/heads/ ? payload['ref'].sub('refs/heads/', '') : nil
      opts[:tag]     = payload['ref'] =~ /refs\/tags/ ? payload['ref'].sub('refs/tags/', '') : nil

      File.write 'last_payload.json', json_string if ENV['DEBUG']

      runner = Runner.new opts
      success = runner.execute

      status 404 unless success

      json runner.response
    end
  end
end
