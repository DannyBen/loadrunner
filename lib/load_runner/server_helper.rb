require 'byebug'

module LoadRunner

  module ServerHelper
    def execute_handlers(opts)
      file = "handlers/#{opts[:repo]}/#{opts[:event]}"
      
      opts.each { |key, value| ENV[key.to_s.upcase] = value }

      if File.exist? file
        run_bg file
        opts.tap do |o|
          o[:handler] = file
        end
      else
        status 404
        opts.tap do |o|
          o[:handler] = file
          o[:error] = 'Could not find any handler to process this webhook'
        end
      end
    end

    def verify_signature(payload_body)
      signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), secret_token, payload_body)
      signature_match = Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE'])
      return halt 401, "Bad Signature" unless signature_match
    end

    def secret_token
      ENV['GITHUB_SECRET_TOKEN']
    end

    def run_bg(cmd)
      job = fork { exec cmd }
      Process.detach job
    end

  end
end