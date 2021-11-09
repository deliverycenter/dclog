# frozen_string_literal: true

class Dclog::Formatter
  LOG_REGEX = /^\[([a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12})\]\s+(.+)$/.freeze

  def initialize
    @silencers = []
  end

  def add_silencer(&block)
    @silencers << block
  end

  def call(severity, timestamp, progname, message)
    return if should_filter?(message)

    msg_regex = message.match(LOG_REGEX)
    request_id = msg_regex.nil? ? nil : msg_regex[1]
    msg = msg_regex.nil? ? message : msg_regex[2]

    "#{JSON.dump(
      severity: severity,
      date: timestamp.strftime("%Y-%m-%d %H:%M:%S"),
      caller: progname,
      request_id: request_id,
      message: msg
    )}\n"
  end

  private

  def should_filter?(message)
    return false if @silencers.empty?

    @silencers.each { |silencer| return true if silencer.call(message) }

    false
  end
end
