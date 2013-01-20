$LOAD_PATH << './lib'
require "net/protocol"
require "beluga/version"
require "beluga/plugin"
require "socket"
require "yaml"

module Beluga
  def self.remove_and_reload(file)
    file = File.join(File.dirname(File.expand_path(__FILE__)), file)
    const = File.basename(file, ".rb").split('_').map{|e| e.capitalize}.join
    Beluga.send(:remove_const, const) if defined?(Beluga.const_get(const)) == 'constant'
    load file
  end

  class Base
    def initialize(config)
      @config = config
      @nick = @config[:nick]
    end

    def load_handler
      Beluga.remove_and_reload('./beluga/handler.rb')
      @handler = Beluga::Handler.new(self, @config, @connection)
    end

    def connect!
      (@connection = Net::BufferedIO.new(TCPSocket.open(@config[:server], 6667))).read_timeout = 240
      load_handler
      setup_user_and_channel
      listen
    end

    def setup_user_and_channel
      raw_send("USER #{@nick} #{@nick} #{@nick} #{@nick}\nNICK #{@nick}")
      @config[:channels].each {|channel| raw_send("JOIN #{channel}")}
    end

    def listen
      begin
        while not defined? stop
          (not @handler.listen) ? stop = true : load_handler
        end
      rescue StandardError => e
        puts e.inspect
      end

      @connection.close
    end

    def raw_send(data)
      puts ">> #{data.strip}"
      @connection.write("#{data}\n")
    end
  end
end