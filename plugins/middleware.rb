require 'middleware'
require 'beluga/plugin'

module Beluga
  class Middleware < Beluga::Plugin
    module Handler
      attr_accessor :middleware, :stack

      def self.extended(object)
        object.load_all_middleware
        puts "Middleware: #{object.middleware}"
      end

      def middleware
        @middleware ||= []
      end

      def stack
#         warez = Class.new do
#           def initialize(app, *args, &block)
#             @app, @args = app, args
#           end
#
#           def call(env)
#             @app.call(env)
#           end
#         end

        @builder ||= ::Middleware::Builder.new
        @builder.tap do |builder|
          middleware.each do |m|
            builder.insert(-1, m, connection: @connection, base: @base)
          end
        end
      end

      def handle(*env)
        stack.call(env)
        super
      end

      def load_all_middleware
        @config['middleware'].each do |m|
          middleware << load_middleware(m)
        end
      end

      def load_middleware(m)
        underscore_m = m.gsub(/(.)([A-Z])/,'\1_\2').downcase
        Beluga.remove_and_reload("../middleware/#{underscore_m}.rb")
        Beluga::Middleware.const_get(m)
      end
    end

    def initialize(base, handler)
      handler.extend(Handler)

      super
    end
  end
end
