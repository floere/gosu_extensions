module Shooter extend Trait
  
  module Position
    def self.front x, y = nil
      # y || (y, x = x, 0)
      y ||= 0
      relative x, y
    end
    def self.relative x, y
      relative_position = CP::Vec2.new x, y
      relative_length   = relative_position.length
      relative_rotation = relative_position.to_angle
      lambda { |_| self.position + (self.rotation - relative_rotation).radians_to_vec2 * relative_length }
    end
  end
  module Velocity
    def self.front initial_speed, random = nil
      if random
        lambda { |_| (self.rotation_vector + CP::Vec2.new(rand*random, rand*random))*initial_speed }
      else
        lambda { |_| self.rotation_vector*initial_speed }
      end
    end
  end
  module Rotation
    def self.custom rotation; lambda { |_| rotation } end
    Frontal   = lambda { |_| self.rotation }
    Right     = lambda { |_| self.rotation + Rotation::Half }
    Backwards = lambda { |_| -self.rotation }
    Left      = lambda { |_| self.rotation - Rotation::Half }
    Default   = Frontal
  end
  
  Shoot = :shoot
  
  manual <<-MANUAL
    Defines:
      range <some range> # This is only needed for targeted shooting, e.g. automatic cannons
      frequency <some shooting frequency>
      shoots <class:thing>
      muzzle_position { position calculation } || frontal # a block
      muzzle_velocity { velocity calculation }
      muzzle_rotation { rotation calculation }
      
    Example:
      frequency 20
      shoots Bullet
      muzzle_position { self.position + self.rotation_vector.normalize*20 } # Or: Shooter::Position.front(20)
      muzzle_velocity { |_| self.rotation_vector.normalize } # Or: Shooter::Velocity.front(1)
      muzzle_rotation { |_| self.rotation }
  MANUAL
  
  attr_accessor :shot_type
  attr_writer :shooting_range, :shooting_rate
  
  def self.included base
    base.extend ClassMethods
  end
  
  def shooting_range
    @shooting_range || @shooting_range = 300
  end
  def shooting_rate
    @shooting_rate || @shooting_rate = (SUBSTEPS**2).to_f/2
  end
  
  module ClassMethods
    def range amount
      InitializerHooks.register self do
        self.shooting_range = amount
      end
    end
    # TODO block
    #
    def frequency amount
      InitializerHooks.register self do
        self.shooting_rate = ((SUBSTEPS**2).to_f/amount)/2
      end
    end
    def shoots type
      InitializerHooks.register self do
        self.shot_type = type
      end
    end
    def muzzle_position lam = nil, &block
      block ||= lam
      InitializerHooks.register self do
        muzzle_position_func &block
      end
    end
    def muzzle_velocity lam = nil, &block
      block ||= lam
      InitializerHooks.register self do
        muzzle_velocity_func &block
      end
    end
    def muzzle_rotation lam = nil, &block
      block ||= lam
      InitializerHooks.register self do
        muzzle_rotation_func &block
      end
    end
  end
  
  def shot
    self.shot_type.new @window
  end
  
  def muzzle_position distance = 10
    instance_eval &(@muzzle_position || @muzzle_position = lambda { |*| self.position + self.rotation_vector * distance })
  end
  def muzzle_velocity target = nil
    instance_eval &(@muzzle_velocity || @muzzle_velocity = lambda { |*| self.rotation_vector })
  end
  def muzzle_rotation target = nil
    instance_eval &(@muzzle_rotation || @muzzle_rotation = lambda { |*| self.rotation })
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
    target.nil? ? true : target.distance_from(self) <= self.shooting_range
  end
  def shoot target = nil
    return unless shoot? target
    
    sometimes :loading, self.shooting_rate do
      projectile = self.shot.shoot_from self
      projectile.rotation = self.muzzle_rotation
      # projectile.velocity = self.muzzle_rotation.radians_to_vec2.normalize
      projectile.speed = self.muzzle_velocity * projectile.velocity + self.speed
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