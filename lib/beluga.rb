$LOAD_PATH << './lib'
require "beluga/version"
require "socket"
require "yaml"
puts Beluga::VERSION
module Beluga
  class Base
    attr_accessor :config
    def initialize
      load_config!
      @servers = @config["servers"]
require 'ruby-debug'; Debugger.start; Debugger.settings[:autoeval] = 1; Debugger.settings[:autolist] = 1; debugger
      connect!
    end

    def connect!

    end

    def load_config!
      @config = YAML::load_file(File.dirname($0) + "/../config/irc.yml")
    end
  end
end

Beluga::Base.new
