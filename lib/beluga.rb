$LOAD_PATH << './lib'
require "beluga/version"
require "socket"
require "thread"
require "yaml"
puts Beluga::VERSION
module Beluga
  class Base
    attr_accessor :config
    def initialize
      load_config!
      puts @config.inspect
      @servers = @config[:servers]
      @threads = []
#require 'ruby-debug'; Debugger.start; Debugger.settings[:autoeval] = 1; Debugger.settings[:autolist] = 1; debugger
      connect!
      
      @threads.each do |thread|
        thread.join
      end
    end

    def connect!
      @servers.each do |server|
        @threads << Thread.new(server) do |s|
          conn = Connection.new(server)
          sleep(5.0)
          conn.start
        end
      end
    end

    def load_config!
      @config = YAML::load_file(File.dirname($0) + "/../config/irc.yml")
    end
  end
  
  class Connection
    def initialize(server)
      @nick = server[:nick]
      @connection = TCPSocket.open(server[:host], 6667)      
      reply("USER #{@nick} #{@nick} #{@nick} #{@nick}")
      reply("NICK #{@nick}")
      server[:channels].each do |channel|
         reply("JOIN #{channel}")
      end
    end
    
    def start
      loop do
        msg = @connection.gets
        puts "<< #{msg.to_s.strip} #{msg.length}"
        
        if /^PING (.*?)\s$/.match(msg)
          reply("PONG #{$1}")
        end
      end
    end
    
    def reply(data)
      puts ">> #{data.strip}"
      @connection.puts(data)
    end
  end
end

Beluga::Base.new
