# frozen_string_literal: true

require 'logger'
require 'active_support/json'

module Dlog
  module Formatters
    class Json < ::Logger::Formatter
      def call(severity, timestamp, _progname, params)
        {
          severity: severity,
          time: timestamp,
          message: params
        }.compact.to_json + "\r\n"
      end
    end
  end
end
