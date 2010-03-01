class Thing
  
  include InitializerHooks
  
  attr_reader :window, :shape
  
  # Every thing knows the window it is attached to.
  #
  def initialize window
    @window = window
  end
  
  # Do something threaded.
  #
  def threaded time, &code
    window.threaded time, code
  end
  
  # Destroy this thing.
  #
  def destroy!
    @window.unregister self
    true
  end
  
  # Some things you can only do every x time units.
  # 
  # Example:
  #   sometimes :loading, self.frequency do
  #     projectile = self.shot.shoot_from self
  #     projectile.rotation = self.muzzle_rotation[target]
  #     projectile.speed = self.muzzle_velocity[target] * projectile.velocity
  #   end
  #
  def sometimes variable, units = 1, &block
    name = :"@#{variable}"
    return if instance_variable_get(name)
    instance_variable_set name, true
    result = block.call
    threaded units do
      self.instance_variable_set name, false
    end
    result
  end
  
  # Add this thing to a space.
  #
  # Note: Adds the body and the shape.
  #
  def add_to space
    space.add_body @shape.body
    space.add_shape @shape
  end
  
  # Include helpers. Multiple Modules (Traits) can be named.
  #
  # Examples:
  # * it_is_a Targetable, Accelerateable
  # * it_is Targeting::Closest
  #
  class << self
    def it_is *traits
      traits.each { |trait| include trait }
    end
    alias it_is_a it_is
  end
  
end