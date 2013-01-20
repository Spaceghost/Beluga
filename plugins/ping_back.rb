require "beluga/plugin.rb"

class Beluga::PingBack < Beluga::Plugin
  def initialize(base, handler)
    super(base, handler)
    handler.extend(ProcessOverride)
  end

  module ProcessOverride
    def self.extended(object)
      class << object
        alias_method :handle_without_pingback, :handle
        alias_method :handle, :pingback_handle
      end
    end

    def pingback_handle(prefix, trailing, command, params)
      @base.raw_send("PRIVMSG #{params.first} :ping!") if command == "PRIVMSG" and trailing.include?(@config[:nick])
      handle_without_pingback(prefix, trailing, command, params)
    end
  end
end
