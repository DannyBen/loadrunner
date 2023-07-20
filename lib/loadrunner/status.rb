require 'loadrunner/github_api'

module Loadrunner
  # Update GitHub pull request status
  class Status
    class << self
      def update(repo:, sha:, state:, context: nil, description: nil, url: nil)
        api = GithubAPI.new

        opts = {
          state:       state,
          target_url:  url,
          context:     context,
          description: description
        }

        api.status repo, sha, opts
      end
    end
  end
end
