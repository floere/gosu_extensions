# Sprite is the basic object in Gosu Extensions.
#
# It is different from Thing in that it has no body. It's just a bodyless, displayed sprite.
#
class Sprite
  
  include VectorUtilities
  include Imageable
  include InitializerHooks
  include ItIsA
  it_is   Moveable
  
  attr_reader :window
  
  # Every thing knows the window it is attached to.
  #
  def initialize window
    @window = window
    self.destroyed = false
    after_initialize
  end
  
  # Default layer is Layer::Players.
  #
  def layer
    Layer::Players
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
      to_execute = block_given? ? block : lambda { amount }
      InitializerHooks.register self do
        self.rotation = to_execute[]
      end
    end
    def random_rotation
      rotation { 2*Math::PI*rand }
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
  
  # Override this.
  #
  def move
    
  end
  
  # Do something threaded.
  #
  # Default is: Instantly, in the next step.
  #
  def threaded time = 1, &code
    self.window.threaded time, &code
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
    threaded units.to_i do
      self.instance_variable_set name, false
    end
    result
  end
  
  # Add this thing to an environment.
  #
  # Note: Adds the body and the shape.
  #
  def add_to environment
    environment.add_body self.shape.body # could develop into adding multiple bodies
    environment.add_shape self.shape
  end
  
  # Destroy this thing.
  #
  attr_writer :destroyed
  def destroyed?
    @destroyed
  end
  def destroyed!
    # Override
  end
  def destroy!
    return if self.destroyed?
    self.destroyed!
    self.window.unregister self
    self.destroyed = true
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
    self.position = CP::Vec2.new(x, y)
  end
  def drawing_rotation
    self.rotation.radians_to_gosu
  end
  def rotation_vector
    self.rotation.radians_to_vec2
  end
  def current_speed
    speed.length
  end
  
  # Movement and Position.
  #
  
  #
  #
  attr_accessor :position, :speed
  attr_reader :rotation
  def rotation= rotation
    @rotation = rotation % (2*Math::PI)
  end
  
end