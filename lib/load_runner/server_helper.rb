module LoadRunner
  module ServerHelper
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