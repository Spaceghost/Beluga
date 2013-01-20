class Beluga::Plugin
  def initialize(base, handler)
    @base = base
    @handler = handler
    puts "!! #{self.class.to_s} Loaded"
  end

  def override(handler)
  end

  def unload
    nil
  end
end