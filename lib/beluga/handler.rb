class Beluga::Handler
  attr_accessor :plugins

  def initialize(base, config, connection)
    @base = base
    @config = config
    @connection = connection
    @plugins = {}
    load_plugins
  end

  def load_plugins
    @config[:plugins].each do |p|
      load_plugin(p)
    end
  end

  def load_plugin(p)
    Beluga.send(:remove_const, p.to_s) if defined?(Beluga.const_get(p)) == 'constant'
    underscore_p = p.gsub(/(.)([A-Z])/,'\1_\2').downcase
    load File.join(File.dirname(File.expand_path(__FILE__)), "../../plugins/#{underscore_p}.rb")
    (@plugins[p] = Beluga.const_get(p).new(@base)).override(self)
  end

  def unload_plugin(p)
    @plugins.delete(p).unload
    Beluga.send(:remove_const, p.to_s) if defined?(Beluga.const_get(p)) == 'constant'
  end

  def reload
    @plugins.values.each { |p| p.unload }
    return true
  end

  def listen
    while msg = @connection.readline
      puts "<< #{msg}"
      /^(:[^\s]*? )?(.*?) :(.*?)$/.match(msg)
      prefix, trailing, command, *params = [$1, $3, ($2 || "").split(" ")].flatten
      handle(prefix, trailing, command, params)
    end
  end

  def handle(prefix, trailing, command, params)
    @base.raw_send("PONG :#{trailing}") and return if command == "PING"
    return reload if command == "PRIVMSG" and trailing.include?("reload handler")
  end
end