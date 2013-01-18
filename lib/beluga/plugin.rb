module Beluga
  class Plugin
    def new(beluga, connection)
      @beluga = beluga
      @connection = connection
    end
  end
end