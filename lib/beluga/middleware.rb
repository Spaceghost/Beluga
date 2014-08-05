module Beluga
  class Stack
    def initialize(base, config, connection)
      @base, @config, @connection = base, config, connection
      @stack = []

      load_all_middleware
    end

    def call(**args, **kwargs)
      msg = args
      /^(:[^\s]*? )?(.*?) :(.*?)$/.match(msg)
      prefix, trailing, command, *params = [$1, $3, ($2 || "").split(" ")].flatten

      @stack.each_with_index do |object, index|
        object.new([prefix, trailing, command, params]).call
      end
    end

    private
    attr_reader :config, :stack

    def load_all_middleware
      @config['middleware'].each do |m|
        load_middleware(m)
      end
    end

    def load_middleware(m)
      underscore_m = m.gsub(/(.)([A-Z])/,'\1_\2').downcase
      Beluga.remove_and_reload("../middleware/#{underscore_m}.rb")
      middleware <<  Beluga::Middleware.const_get(p)
    end
  end

  module Middleware

  end
end
