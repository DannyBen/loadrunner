module LoadRunner
  module ServerHelper
    def verify_signature(payload_body, signature)
      if secret_token and !signature
        return halt 401, "Client did not send a signature"
      end

      if !secret_token and signature
        return halt 401, "Server secret token is not configured"
      end

      if secret_token and signature
        expected_signature = generate_signature payload_body
        signature_match = Rack::Utils.secure_compare(expected_signature, signature)
        return halt 401, "Signature mismatch" unless signature_match
      end
    end

    def secret_token
      ENV['GITHUB_SECRET_TOKEN']
    end

    def generate_signature(payload_body)
      'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), secret_token, payload_body)
    end
  end
end