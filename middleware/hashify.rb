module Beluga
  class Middleware
    class Hashify
      def initialize(app, **kwargs)
        @app = app
      end

      def call(env)
        @app.call(
          %i|prefix trailing command params|.zip(*env).to_h.tap do |hash|

            puts "ENV => #{hash}" if hash.values.any? &:nil?
          end
        )
      end
    end
  end
end
