require 'term/ansicolor'

module Capybara
  module RailsLogInspection
    class << self
      def logger_target
        @logger_target ||= StringIO.new
      end

      def logger(level = nil)
        logger = Logger.new(logger_target)
        logger.level = level || default_log_level
        logger
      end

      attr_writer :backtrace_clean_patterns, :default_log_level, :rack_log_level, :filter_request_starts

      def default_log_level
        Logger::INFO
      end

      def rack_log_level
        Logger::WARN
      end

      def filter_request_starts
        @filter_request_starts ||= true
      end

      def clean_rack_output(lines)
        lines.reject { |line| line.strip.empty? || (filter_request_starts && line[%r{^Started }]) }
      end

      def backtrace_clean_patterns
        @backtrace_clean_patterns ||= [ %r{/gems/}, %r{/ruby/1} ]
      end

      def clean_backtrace(exception)
        exception.backtrace.collect(&:strip).reject { |line| line.empty? || backtrace_clean_patterns.any? { |pattern| line[pattern] } }
      end

      def add_backtrace(exception)
        clean_backtrace(exception).each { |line| logger_target << "  #{line.strip}\n" }
      end
    end

    def reset_logs
      Capybara::RailsLogInspection.logger_target.rewind
      Capybara::RailsLogInspection.logger_target.truncate(0)
    end

    def output_logs(target = $stderr)
      Capybara::RailsLogInspection.logger_target.rewind

      lines = Capybara::RailsLogInspection.logger_target.read.lines

      Capybara::RailsLogInspection.clean_rack_output(lines).each do |line|
        target.print(Term::ANSIColor.red, line, Term::ANSIColor.reset)
      end

      reset_logs
    end
  end
end

Rails.logger = Capybara::RailsLogInspection.logger

Capybara.server do |app, port|
  require 'rack/handler/webrick'

  responder = lambda { |request, response|
    class << response
      def set_error(ex, backtrace = false)
        Capybara::RailsLogInspection.add_backtrace(ex)
      end
    end
  }

  Rack::Handler::WEBrick.run(app, :Port => port, :AccessLog => [], :Logger => Capybara::RailsLogInspection.logger(Capybara::RailsLogInspection.rack_log_level), :RequestCallback => responder)
end

