module Shooter
  
  def self.included base
    base.extend ClassMethods
  end
  
  module ClassMethods
    def range amount
      InitializerHooks.register self do
        self.range = amount
      end
    end
    def frequency amount
      InitializerHooks.register self do
        self.frequency = amount
      end
    end
    def shoots type
      InitializerHooks.register self do
        self.shot_type = type
      end
    end
    def muzzle_position &block
      InitializerHooks.register self do
        muzzle_position_func &block
      end
    end
    def muzzle_velocity &block
      InitializerHooks.register self do
        muzzle_velocity_func &block
      end
    end
    def muzzle_rotation &block
      InitializerHooks.register self do
        muzzle_rotation_func &block
      end
    end
  end
  
  attr_reader :muzzle_position, :muzzle_velocity, :muzzle_rotation
  attr_accessor :shot_type, :range, :frequency
  
  def shot
    self.shot_type.new @window
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
  
  if self.kind_of?(::Targeting)
    def target *targets
      return if targets.empty?
      target = acquire *targets
      shoot target
    end
  end
  
end