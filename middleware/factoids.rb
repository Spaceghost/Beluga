require 'pry'
require 'sdbm'

module Beluga
  class Middleware
    class Factoids
      def initialize(app, **kwargs)
        @database = SDBM.new('beluga')
      end

      def call(env)
        return env unless (env[:trailing] || '').start_with?('!')

        factoid_name = env[:trailing].sub('!', '')
        factoid = @database.fetch(factoid_name, "No known factoid") if factoid_name

        env
      end
    end
  end
end

