$LOAD_PATH << './lib'
require "beluga/version"
require "socket"
require "thread"
require "yaml"
puts Beluga::VERSION

Dir.glob(File.dirname($0) + "/../plugins/*.rb") do |plugin_path|
  load(plugin_path) #for later... name = File.basename(plugin_path, '.rb').gsub(/(^|_)(.)/) { $2.upcase }
end

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
      
      @threads.each {|thread| thread.join}
    end

    def connect!
      @servers.each do |server|
        @threads << Thread.new(server) do |s|
          (conn = Connection.new(server)).start
        end
      end
    end

    def load_config!
      @config = YAML::load_file(File.dirname($0) + "/../config/irc.yml")
    end
  end
  
  class Connection
    def initialize(info)
      @info = info
      @connection = TCPSocket.open(server[:host], 6667)      
      reply("USER #{@info[:nick]} #{@info[:nick]} #{@info[:nick]} #{@info[:nick]}")
      reply("NICK #{@info[:nick]}")
      info[:channels].each {|channel| reply("JOIN #{channel}")}
    end
    
    def start
      loop do
        puts "<< #{(msg = @connection.gets).to_s.strip}"
        reply("PONG #{$1}") if /^PING (.*?)\s$/.match(msg)
      end
    end
    
    def reply(data)
      puts ">> #{data.strip}"
      @connection.puts(data)
    end
  end
  
  class Plugin
    def new(beluga, connection)
      @beluga = beluga
      @connection = connection
    end
  end
end

Beluga::Base.new
