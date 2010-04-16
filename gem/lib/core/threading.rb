# Use this if you want something to run only some times,
# or something to run after x time.
#
module Threading
  
  # Do something threaded.
  #
  # Default is: Instantly, in the next step.
  #
  # Note: Can also be called with after.
  #
  def threaded time = 1, &code
    self.window.scheduling.add time, &code
  end
  alias after threaded
  
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
    name = :"@__sometimes_#{variable}"
    return if instance_variable_get(name)
    instance_variable_set name, true
    result = block.call
    threaded units.to_i do
      self.instance_variable_set name, false
    end
    result
  end
  
end