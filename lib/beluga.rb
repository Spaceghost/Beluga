$LOAD_PATH << './lib'
require "net/protocol"
require "beluga/version"
require "beluga/plugin"
require "socket"
require "yaml"

class Beluga::Base
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
    (@connection = Net::BufferedIO.new(TCPSocket.open(@config[:server], 6667))).read_timeout = 240
    load_handler
    setup_user_and_channel
    listen
  end

  def setup_user_and_channel
    raw_send("USER #{@nick} #{@nick} #{@nick} #{@nick}")
    raw_send("NICK #{@nick}")
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