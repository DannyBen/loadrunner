module LoadRunner

  # Executes event handlers
  class Runner
    attr_reader :opts
    attr_accessor :response, :handlers_dir

    def initialize(opts)
      @handlers_dir = 'handlers'
      @opts = opts
    end

    # Execute all matching handlers based on the input payload. This method
    # populates the `#response` object, and returns true on success.
    def execute
      set_environment_vars
      
      @response = opts.dup
      handlers = locate_handlers

      if handlers.empty?
        @response[:matching_handlers] = matching_handlers
        @response[:error] = "Could not find any handler to process this webhook. Please implement one of the 'matching_handlers'."
        return false
      else
        execute_all handlers
        @response[:executed_handlers] = handlers
        return true
      end
    end

    private

    # Find all handlers that fit the payload meta data.
    def locate_handlers
      handlers = []

      matching_handlers.each do |handler|
        handlers << handler if File.exist? handler
      end

      handlers
    end

    # Execute all handlers.
    def execute_all(handlers)
      handlers.each do |handler|
        run_bg handler
      end
    end

    # Run a command in the background.
    def run_bg(cmd)
      job = fork { exec cmd }
      Process.detach job
    end

    # Set all payload meta data as environment variables so that the
    # handler can use them.
    def set_environment_vars
      opts.each { |key, value| ENV["LOADRUNNER_#{key.to_s.upcase}"] = value }
    end

    def matching_handlers
      base = "#{handlers_dir}/#{opts[:repo]}/#{opts[:event]}"
      handlers = [
        "#{handlers_dir}/global",
        "#{handlers_dir}/#{opts[:repo]}/global",
        "#{base}"
      ]

      handlers.tap do |h|
        h << "#{base}@branch=#{opts[:branch]}" if opts[:branch]
        h << "#{base}@tag=#{opts[:tag]}" if opts[:tag]
      end
    end

  end
end