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
    @config['plugins'].each do |p|
      load_plugin(p)
    end
  end

  def load_plugin(p)
    underscore_p = p.gsub(/(.)([A-Z])/,'\1_\2').downcase
    Beluga.remove_and_reload("../plugins/#{underscore_p}.rb")
    @plugins[p] = Beluga.const_get(p).new(@base, self)
  end

  def unload_plugins
    @store_array = @plugins.keys.map{ |p| [p, @plugins[p].unload] }.flatten
    #@store = Hash[*@store_array] || {}
  end

  def unload_plugin(p)
    plugin = @plugins.delete(p)
    plugin.unload if plugin
    unload_plugins
  end

  def listen
    while not @reload
      puts "<< #{msg = @connection.readline}"
      /^(:[^\s]*? )?(.*?) :(.*?)$/.match(msg)
      prefix, trailing, command, *params = [$1, $3, ($2 || "").split(" ")].flatten
      handle(prefix, trailing, command, params)
    end

    return true
  end

  def handle(prefix, trailing, command, params)
    @base.raw_send("PONG :#{trailing}") and return if command == "PING"

    if command == "PRIVMSG" and /^#{@config['prefix']}(\w*) ?(\w*)/.match(trailing)
      case $1
        when "reload"
          unload_plugins and @reload = true
        #when "unload" then unload_plugin($2) and @reload = true
        #when "load" then load_plugin($2)
      end
    end
  end
end
