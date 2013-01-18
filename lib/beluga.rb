$LOAD_PATH << './lib'
require "beluga/version"
require "beluga/plugin"
require "socket"
require "yaml"
puts Beluga::VERSION

module Beluga
  class Base
    attr_accessor :reload_command

    def initialize(config)
      @config = config
      @nick = @config[:nick]
    end

    def load_handler
      Beluga.send(:remove_const, 'Handler') if defined?(Beluga::Handler) == 'constant'
      load File.join(File.dirname(File.expand_path(__FILE__)), './beluga/handler.rb')
      @handler = Beluga::Handler.new(self, @config, @connection)
    end

    def connect!
      @connection = TCPSocket.open(@config[:server], 6667)
      load_handler
      setup_user_and_channel
      process
    end

    def setup_user_and_channel
      raw_send("USER #{@nick} #{@nick} #{@nick} #{@nick}")
      raw_send("NICK #{@nick}")
      @config[:channels].each {|channel| raw_send("JOIN #{channel}")}
    end

    def process
      loop do
        /^(:[^\s]*? )?(.*?) :(.*?)$/.match(@connection.gets)
        prefix, trailing, command, *params = [$1, $3, ($2 || "").split(" ")].flatten
        raw_send("PONG :#{trailing}") and next if command == "PING"
        load_handler and next if command == "PRIVMSG" and trailing.include?(@reload_command)
        @handler.handle(prefix, trailing, command, params) rescue true
      end
    end

    def raw_send(data)
      puts ">> #{data.strip}"
      @connection.puts(data)
    end
  end
end
