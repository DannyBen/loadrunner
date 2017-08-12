require 'sinatra'
require "sinatra/reloader" if development?
require 'json'
require 'active_support/core_ext/hash/indifferent_access'
require 'byebug'

set port: 3000
set bind: '0.0.0.0'

ENV['SECRET_TOKEN'] = '123'

post '/payload' do
  request.env['HTTP_X_HUB_SIGNATURE']

  request.body.rewind
  payload_body = request.body.read

  verify_signature payload_body

  push = ActiveSupport::HashWithIndifferentAccess.new JSON.parse payload_body

  branch = push[:ref] =~ /refs\/head/ ? push[:ref].sub('refs/heads/', '') : nil;
  tag    = push[:ref] =~ /refs\/tags/ ? push[:ref].sub('refs/tags/', '') : nil;

  result = {
    event: request.env['HTTP_X_GITHUB_EVENT'],
    repo: push[:repository][:name],
    branch: branch,
    tag: tag
    # payload: push
  }

  result.inspect
end

post '/debug' do
  request.env['HTTP_X_HUB_SIGNATURE']
end

def verify_signature(payload_body)
  signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), ENV['SECRET_TOKEN'], payload_body)
  signature_match = Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE'])
  return halt 401, "Bad Signature" unless signature_match
end