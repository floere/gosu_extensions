module Shooter
  
  attr_reader :muzzle_position, :muzzle_velocity, :muzzle_rotation
  attr_accessor :range, :frequency
  
  def shoots type
    @shot_type = type
  end
  
  def shot
    @shot_type.new @window
  end
  
  def muzzle_position_func &position
    @muzzle_position = position
  end
  def muzzle_velocity_func &velocity
    @muzzle_velocity = velocity
  end
  def muzzle_rotation_func &rotation
    @muzzle_rotation = rotation
  end
  def shoot? target = nil
    target.distance_from(self) < self.range unless target.nil?
  end
  def shoot target = nil
    return unless shoot? target
    sometimes :loading, self.frequency do
      projectile = self.shot.shoot_from self
      projectile.rotation = self.muzzle_rotation[target]
      projectile.speed = self.muzzle_velocity[target] * projectile.velocity
    end
  end
  
  if self.kind_of?(Targeting)
    def target *targets
      return if targets.empty?
      target = acquire *targets
      shoot target
    end
  end
  
end