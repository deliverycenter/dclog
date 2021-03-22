# frozen_string_literal: true

require 'rails'
require 'sidekiq'
require_relative 'dlog/version'
require_relative 'dlog/formatters/json'

module Dlog
  class << self
    def method_missing(method, *args)
      caller = caller_locations.first.label
      message = args[0]
      params = args[1..-1].blank? ? {} : args[1..-1]
      log_to_stdout(method, caller, message, params)
    end

    def respond_to_missing?(method, include_private = false)
      %i[info warn error fatal unknown].include?(method) || super
    end

    private

    def log_to_stdout(severity, _caller, message, _params)
      return if Rails.env.test?

      severity = :unknown unless %i[info warn error fatal].include?(severity)

      Sidekiq.logger.send(severity, message)
      Rails.logger.send(severity, message)
    end
  end
end
