module LoadRunner
  module ServerHelper
    def verify_signature(payload_body)
      request_signature = request.env['HTTP_X_HUB_SIGNATURE']

      if secret_token and !request_signature
        return halt 401, "Client did not send a signature"
      end

      if !secret_token and request_signature
        return halt 401, "Server secret token is not configured"
      end

      if secret_token and request_signature
        signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), secret_token, payload_body)
        signature_match = Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE'])
        return halt 401, "Signature mismatch" unless signature_match
      end
    end

    def secret_token
      ENV['GITHUB_SECRET_TOKEN']
    end
  end
end