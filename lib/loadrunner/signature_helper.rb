module Loadrunner
  module SignatureHelper
    def verify_signature(payload_body, signature)
      return :no_client if secret_token && !signature
      return :no_server if !secret_token && signature
      return :ok        if !secret_token && !signature

      expected_signature = generate_signature payload_body
      signature_match = Rack::Utils.secure_compare(expected_signature, signature)
      signature_match ? :ok : :mismatch
    end

    def generate_signature(payload_body)
      sha = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), secret_token, payload_body)
      "sha1=#{sha}"
    end

    def secret_token
      ENV['GITHUB_SECRET_TOKEN']
    end
  end
end
