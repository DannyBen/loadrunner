module Loadrunner
  module ServerHelper
    def halt_messages
      {
        no_client: "Client did not send a signature",
        no_server: "Server secret token is not configured",
        mismatch:  "Signature mismatch"
      }
    end
  end
end
