module Beluga
  class Handler
    def initialize(base, config, connection)
      (@base = base).reload_command = "reload handler"
      @config = config
      @connection = connection
    end

    def handle(prefix, trailing, command, params)
      puts "<< #{prefix} #{command} #{params.join(" ")} :#{trailing}"
    end

    def say(msg, channel)
      @base.raw_send("PRIVMSG #{channel} :#{msg}")
    end
  end
end