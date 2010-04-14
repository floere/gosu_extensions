# Thing is a physical version of a sprite. Collides and has a mass and a moment.
#
class Thing < Sprite
  
  attr_reader :shape
  
  def mass
    0.1
  end
  def moment
    0.1
  end
  def friction
    100.0
  end
  
  def layer
    Layer::Players
  end
  
  class << self
    @@form_shape_class_mapping = {
      :circle  => CP::Shape::Circle, # :circle, radius
      :poly    => CP::Shape::Poly,   # :poly, CP::Vec2.new(-22, -18), CP::Vec2.new(-22, -10), etc.
      :segment => CP::Shape::Segment # :segment, ...
      # TODO :image => # Special, just traces the extent of the image.
    }
    def shape form, *args
      form_shape_class_mapping = @@form_shape_class_mapping
      define_method :radius do
        args.first # TODO fix!
      end
      InitializerHooks.prepend self do
        shape_class = form_shape_class_mapping[form]
        raise "Shape #{form} does not exist." unless shape_class
        
        params = []
        params << CP::Body.new(self.mass, self.moment)
        params += args
        params << CP::Vec2.new(0.0, 0.0)
        
        @shape = shape_class.new *params
      end
    end
    def mass amount
      define_method :mass do
        amount
      end
    end
    def moment amount
      define_method :moment do
        amount
      end
    end
    def friction amount
      define_method :friction do
        amount
      end
    end
    # TODO needed?
    #
    def velocity amount = nil, &block
      to_execute = block_given? ? block : lambda { amount }
      InitializerHooks.register self do
        self.velocity = to_execute[]
      end
    end
    
    def collision_type type
      to_execute = lambda do |shape|
        shape.collision_type = type
      end
      InitializerHooks.append self do
        # Ensure @shape exists
        #
        InitializerHooks.append self.class, &to_execute unless @shape
        to_execute[@shape]
      end
    end
    
  end
  
  # Add this thing to an environment.
  #
  # Note: Adds the body and the shape.
  #
  def add_to environment
    environment.add_body self.shape.body # could develop into adding multiple bodies
    environment.add_shape self.shape
  end
  
  # Movement and Position
  #
  
  #
  #
  def speed= v
    @shape.body.v = v
  end
  def speed
    @shape.body.v
  end
  #
  #
  def rotation= rotation
    @shape.body.a = rotation % (2*Math::PI)
  end
  def rotation
    @shape.body.a
  end
  #
  #
  def position= position
    @shape.body.p = position
  end
  def position
    @shape.body.p
  end
  #
  #
  def friction= friction
    @shape.u = friction
  end
  def friction
    @shape.u
  end
  # 
  #
  def torque= torque
    @shape.body.t = torque
  end
  def torque
    @shape.body.t
  end
  
  # Movement rules
  #
  # Note: Use these in method move.
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