module LoadRunner

  class Runner
    attr_reader :opts
    attr_accessor :response

    def initialize(opts)
      @opts = opts
    end

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

    def locate_handlers
      handlers = []

      matching_handlers.each do |handler|
        handlers << handler if File.exist? handler
      end

      handlers
    end

    def execute_all(handlers)
      handlers.each do |handler|
        run_bg handler
      end
    end

    def run_bg(cmd)
      job = fork { exec cmd }
      Process.detach job
    end

    def set_environment_vars
      opts.each { |key, value| ENV[key.to_s.upcase] = value }
    end

    def matching_handlers
      base = "handlers/#{opts[:repo]}/#{opts[:event]}"
      handlers = ["#{base}"]

      handlers.tap do |h|
        h << "#{base}@branch=#{opts[:branch]}" if opts[:branch]
        h << "#{base}@tag=#{opts[:tag]}" if opts[:tag]
      end
    end

  end
end