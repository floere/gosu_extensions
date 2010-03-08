# A moveable has a shape, speed etc.
#
# TODO moveable should only have active components, like accelerate etc. Positioning etc. should go to Thing.
#
class Moveable < Thing
  
  def initialize window
    super window
    after_initialize
  end
  
  class << self
    
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
    
  end
  
  # Return a random vector with a given strength.
  #
  def random_vector strength = 1.0
    CP::Vec2.new(rand-0.5, rand-0.5).normalize! * strength
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
    Math.sqrt(speed.x**2 + speed.y**2)
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
  
  # Wrap to the other side of the screen when we fly off the edge.
  #
  def move
    
  end
  
  # Methods for controls.
  #
  def accelerate strength = 1
    self.speed += self.rotation_vector * strength/SUBSTEPS
  end
  
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
  def destroy_on_hitting_x
    destroy! if position.x > window.screen_height || position.x < 0
  end
  def destroy_on_hitting_y
    destroy! if position.y > window.screen_height || position.y < 0
  end
  
end