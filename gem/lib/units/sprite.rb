# Sprite is the basic object in Gosu Extensions.
#
# It is different from Thing in that it has no body. It's just a bodyless, displayed sprite.
#
class Sprite
  
  include VectorUtilities
  include Imageable
  include InitializerHooks
  include Threading
  include ItIsA
  it_is   Moveable
  
  attr_reader :window,
              :objects
  attr_accessor :position,
                :speed
  
  # Every thing knows the window it is attached to.
  #
  # Also, it knows who it is managed by.
  #
  def initialize window
    @window  = window
    @objects = Thing === self ? window.things : window.sprites
    after_initialize
  end
  
  # Makes the object visible.
  #
  def show
    self.speed     = CP::Vec2.new(0,0)
    self.destroyed = false
    objects.register self
  end
  
  # Default layer is Layer::Players.
  #
  def layer
    Layer::Ambient
  end
  # Default rotation is upwards.
  #
  def rotation
    @rotation || -Rotation::Quarter
  end
  #
  #
  def rotation= rotation
    @rotation = rotation % (2*Math::PI)
  end
  
  class << self
    
    # Define a layer.
    #
    def layer layer
      define_method :layer do
        layer
      end
    end
    
    #
    #
    def rotation amount = nil, &block
      block ||= lambda { amount }
      InitializerHooks.append self do
        self.rotation = block.call
      end
    end
    def random_rotation
      rotation { Rotation::Full*rand }
    end
    
    # Plays a random sound of the given sounds.
    #
    def plays paths, options = {}
      paths = [*paths]
      InitializerHooks.register self do
        sound = Gosu::Sample.new self.window, File.join(Resources.root, paths[rand(paths.size)])
        sound.play options[:volume] || 1.0
      end
    end
    
  end
  
  # A sprite is not added to the physical environment.
  #
  # Override if you want it to.
  #
  def add_to environment; end
  
  # Override this method to do stuff after it is destroyed.
  #
  def destroyed!; end
  
  # Destroy this thing.
  #
  attr_writer :destroyed
  def destroyed?
    @destroyed
  end
  def destroy!
    return if self.destroyed?
    self.destroyed! # invoke callback
    self.destroyed = true
    self.objects.remove self
    # self.window.unregister self # TODO self.owner.unregister self
  end
  
  # Revives this thing.
  #
  # TODO Override in Lives.
  #
  def revive
    show unless objects.registered?(self)
  end
  
  # Draws its image.
  #
  def draw
    self.image.draw_rot self.position.x, self.position.y, self.layer, self.drawing_rotation, 0.5, 0.5, *self.current_size
  end
  def current_size
    [1.0, 1.0] # default implementation - change this to [1.0, 2.0] if you want a "light" version ;)
  end
  
  # Derived Position/Movement methods.
  #
  def warp vector
    self.position = vector
  end
  # Directly set the position of our Moveable.
  #
  def warp_to x, y
    warp CP::Vec2.new(x, y)
  end
  def drawing_rotation
    self.rotation.radians_to_gosu
  end
  def rotation_vector
    self.rotation.radians_to_vec2
  end
  def current_speed
    speed.length # Hm, speed should already be the absolute value.
  end
  
  # Movement and Position.
  #
  # Sprite Movement is not thought of as very realistic (no damping for example).
  # These are just a few simple rules.
  #
  def move
    self.position += self.speed/SUBSTEPS
    moved
  end
  
  # Callback where you can make it obey rules.
  #
  def moved; end
  
  # Movement rules
  #
  # Note: Use these in method move.
  #
  def bounce_off_border_x elasticity = 1.0
    if position.x > window.screen_width || position.x < 0
      self.speed.x = -self.speed.x.to_f*elasticity
    end
  end
  def bounce_off_border_y elasticity = 1.0
    if position.y > window.screen_height || position.y < 0
      self.speed.y = -self.speed.y.to_f*elasticity
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
  def on_hitting_border &block
    on_hitting_x &block
    on_hitting_y &block
  end
  def rotate_towards_velocity
    self.rotation = self.speed.to_angle
  end
  
end