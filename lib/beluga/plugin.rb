class Beluga::Plugin
  def initialize(base)
    @base = base
    puts "!! #{self.class.to_s} Loaded"
  end

  def override(handler)
  end

  def unload
  end
end