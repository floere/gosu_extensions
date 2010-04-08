# A moveable has a shape, speed etc.
#
# TODO moveable should only have active components, like accelerate etc. Positioning etc. should go to Thing.
#
module Moveable extend Trait
  
  Accelerate = :accelerate; def self.accelerate strength = 1.0; [Accelerate, strength] end
  Left       = :move_left;  def self.left       strength = 1.0; [Left,       strength] end
  Right      = :move_right; def self.right      strength = 1.0; [Right,      strength] end
  Up         = :move_up;    def self.up         strength = 1.0; [Up,         strength] end
  Down       = :move_down;  def self.down       strength = 1.0; [Down,       strength] end
  Backwards  = :backwards;  def self.backwards  strength = 1.0; [Backwards,  strength] end
  # TODO Jump       = :jump
  
  def self.included klass
    klass.extend ClassMethods
  end
  
  module ClassMethods
    
    # Initial setting.
    #
    def friction amount = nil, &block
      to_execute = block_given? ? block : lambda { amount }
      InitializerHooks.register self do
        self.friction = to_execute[]
      end
    end
    def velocity amount = nil, &block
      to_execute = block_given? ? block : lambda { amount }
      InitializerHooks.register self do
        self.velocity = to_execute[]
      end
    end
    def rotation amount = nil, &block
      to_execute = block_given? ? block : lambda { amount }
      InitializerHooks.register self do
        self.rotation = to_execute[]
      end
    end
    
    def random_rotation
      rotation { 2*Math::PI*rand }
    end
    
  end
  
  # Directly set the position of our Moveable using a vector.
  #
  def warp vector
    @shape.body.p = vector
  end
  
  # Directly set the position of our Moveable.
  #
  def warp_to x, y
    @shape.body.p = CP::Vec2.new(x, y)
  end
  
  # Directly set the position of our Moveable.
  #
  def position= position
    @shape.body.p = position
  end
  def position
    @shape.body.p
  end
  
  # Directly set the torque of our Moveable.
  #
  def torque= torque
    @shape.body.t = torque
  end
  def torque
    @shape.body.t
  end
  
  # Directly set the speed of our Moveable.
  #
  def speed= v
    @shape.body.v = v
  end
  def speed
    @shape.body.v
  end
  def current_speed
    speed.length
  end
  
  # Directly set the rotation of our Moveable.
  #
  def rotation= rotation
    @shape.body.a = rotation % (2*Math::PI)
  end
  def rotation
    @shape.body.a
  end
  def drawing_rotation
    self.rotation.radians_to_gosu
  end
  def rotation_vector
    @shape.body.a.radians_to_vec2
  end
  
  def friction= friction
    @shape.u = friction
  end
  def friction
    @shape.u
  end
  
  # Length is the vector length you want.
  #
  # Note: radians_to_vec2
  #
  def rotation_as_vector length
    rotation = -self.rotation + Math::PI / 2
    x = Math.sin rotation
    y = Math.cos rotation
    total_length = Math.sqrt(x**2 + y**2)
    multiplier = length / total_length
    CP::Vec2.new(x * multiplier, y * multiplier)
  end
  
  def move
    
  end
  
  # Methods for controls.
  #
  def accelerate strength = 1.0
    self.speed += self.rotation_vector * strength/SUBSTEPS
  end
  def move_left strength = 1.0
    self.speed += CP::Vec2.new(-strength.to_f/SUBSTEPS, 0) 
  end
  def move_right strength = 1.0
    self.speed += CP::Vec2.new(strength.to_f/SUBSTEPS, 0) 
  end
  def move_up strength = 1.0
    self.speed += CP::Vec2.new(0, -strength.to_f/SUBSTEPS) 
  end
  def move_down strength = 1.0
    self.speed += CP::Vec2.new(0, strength.to_f/SUBSTEPS) 
  end
  def backwards strength = 1.0
    accelerate -0.5*strength
  end
  # def jump strength = 100
  #   self.speed += CP::Vec2.new(0, -strength.to_f/SUBSTEPS) if self.current_speed <= 1
  # end
  
  # Movement rules
  #
  # Note: Call in method move.
  #
  def bounce_off_border_x elasticity = 1.0
    if position.x > window.screen_width || position.x < 0
      shape.body.v.x = -shape.body.v.x.to_f*elasticity
    end
  end
  def bounce_off_border_y elasticity = 1.0
    if position.y > window.screen_height || position.y < 0
      shape.body.v.y = -shape.body.v.y.to_f*elasticity
    end
  end
  def bounce_off_border elasticity = 1.0
    bounce_off_border_x elasticity
    bounce_off_border_y elasticity
  end
  def wrap_around_border_x
    if position.x > window.screen_width
      position.x -= window.screen_width
    elsif position.x < 0
      position.x += window.screen_width
    end
  end
  def wrap_around_border_y
    if position.y > window.screen_height
      position.y -= window.screen_height
    elsif position.y < 0
      position.y += window.screen_height
    end
  end
  def wrap_around_border
    wrap_around_border_x
    wrap_around_border_y
  end
  def obey_gravity
    self.speed += window.gravity_vector
  end
  def on_hitting_x
    yield if block_given? && position.x > window.screen_width || position.x < 0
  end
  def on_hitting_y
    yield if block_given? && position.y > window.screen_height || position.y < 0
  end
  def rotate_towards_velocity
    self.rotation = self.speed.to_angle
  end
  
end