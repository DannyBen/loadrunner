module Loadrunner
  # Executes event hooks
  class Runner
    attr_reader :opts
    attr_accessor :response, :hooks_dir

    def initialize(opts)
      @hooks_dir = 'hooks'
      @opts = opts
    end

    # Execute all matching hooks based on the input payload. This method
    # populates the `#response` object, and returns true on success.
    def execute
      set_environment_vars

      @response = opts.dup
      hooks = locate_hooks
      @response[:matching_hooks] = matching_hooks

      if hooks.empty?
        @response[:error] = "Could not find any hook to process this request. Please implement one of the 'matching_hooks'."
        return false
      else
        execute_all hooks
        @response[:executed_hooks] = hooks
        return true
      end
    end

  private

    # Find all hooks that fit the payload meta data.
    def locate_hooks
      hooks = []

      matching_hooks.each do |hook|
        hooks << hook if File.exist? hook
      end

      hooks
    end

    # Execute all hooks.
    def execute_all(hooks)
      hooks.each do |hook|
        run_bg hook
      end
    end

    # Run a command in the background.
    def run_bg(cmd)
      job = fork { exec cmd }
      Process.detach job
    end

    # Set all payload meta data as environment variables so that the
    # hook can use them.
    def set_environment_vars
      opts.each { |key, value| ENV["LOADRUNNER_#{key.to_s.upcase}"] = value }
    end

    def matching_hooks
      base = "#{hooks_dir}/#{opts[:repo]}/#{opts[:event]}"

      hooks = [
        "#{hooks_dir}/global",
        "#{hooks_dir}/#{opts[:repo]}/global",
        "#{base}",
      ]

      hooks << "#{base}@branch=#{opts[:branch]}" if opts[:branch]

      if opts[:tag]
        hooks << "#{base}@tag=#{opts[:tag]}"
        hooks << "#{base}@tag"
      end

      hooks
    end
  end
end
