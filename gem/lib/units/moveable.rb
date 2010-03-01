# A moveable has a shape, speed etc.
#
class Moveable < Thing
  
  def initialize
    super
    after_initialize
  end
  
  class << self
    
    # def register value, block = nil, &block
    #   to_execute = if block_given?
    #     block
    #   else
    #     lambda { amount }
    #   end
    #   InitializerHooks.register self do
    #     self.friction = to_execute[]
    #   end
    # end
    
    def friction amount = nil, &block
      to_execute = if block_given?
        block
      else
        lambda { amount }
      end
      InitializerHooks.register self do
        self.friction = to_execute[]
      end
    end
    def velocity amount = nil, &block
      to_execute = if block_given?
        block
      else
        lambda { amount }
      end
      InitializerHooks.register self do
        self.velocity = to_execute[]
      end
    end
    def rotation amount = nil, &block
      to_execute = if block_given?
        block
      else
        lambda { amount }
      end
      InitializerHooks.register self do
        self.rotation = to_execute[]
      end
    end
    
  end
  
  def random_vector strength = 1
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
  
  def friction= friction
    @shape.u = friction
  end
  def friction
    @shape.u
  end
  
  def rotation_vector
    @shape.body.a.radians_to_vec2
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
  
  def velocity
    @shape.body.v
  end
  
end