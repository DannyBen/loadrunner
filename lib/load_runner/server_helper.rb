module LoadRunner
  module ServerHelper
    def verify_signature(payload_body, signature)
      return :no_client if secret_token and !signature
      return :no_server if !secret_token and signature
      return :ok        if !secret_token and !signature

      expected_signature = generate_signature payload_body
      signature_match = Rack::Utils.secure_compare(expected_signature, signature)
      return signature_match ? :ok : :mismatch
    end

    def generate_signature(payload_body)
      'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), secret_token, payload_body)
    end

    def secret_token
      ENV['GITHUB_SECRET_TOKEN']
    end

    def halt_messages
      {
        no_client: "Client did not send a signature",
        no_server: "Server secret token is not configured",
        mismatch: "Signature mismatch"
      }
    end
  end
end