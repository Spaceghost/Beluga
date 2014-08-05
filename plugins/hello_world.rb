require 'beluga/plugin'

module Beluga
  class HelloWorld < Beluga::Plugin
#     module Handler
#       def handle(prefix, trailing, command, params)
#         require 'pry'; binding.pry
#
#         if command == "PRIVMSG"#  and "#{@config['nick']}: #{@config['prefix']}hello" == trailing
#           @base.raw_send("PRIVMSG #{params.first} :hello world!")
#         end
#
#         super
#       end
#     end

   def initialize(base, handler)
      super(base, handler)
      require 'pry'; binding.pry
    end
  end
end
