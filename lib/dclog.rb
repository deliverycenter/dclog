# frozen_string_literal: true

require 'rails'
require_relative 'dclog/version'

begin
  require 'sidekiq'
rescue LoadError
  puts 'The Sidekiq gem is not installed'
end

module Dclog
  LOG_REGEX = /^\[([a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12})\]\s+(.+)$/.freeze

  class << self
    def method_missing(method, *args)
      caller = caller_locations.first.label
      message = args[0]

      log_to_stdout(method, caller, message)
    end

    def respond_to_missing?(method, include_private = false)
      valid_level?(method) || super
    end

    private

    def valid_level?(severity)
      %i[info warn error fatal debug].include?(severity)
    end

    def raise_no_method_error!(severity)
      raise NoMethodError, "undefined method '#{severity}' for Dclog:Class"
    end

    def log_to_stdout(severity, caller, message)
      raise_no_method_error!(severity) unless valid_level?(severity)

      Sidekiq.logger.send(severity, caller) { message } if defined?(Sidekiq)
      Rails.logger.send(severity, caller) { message }
    end
  end
end
