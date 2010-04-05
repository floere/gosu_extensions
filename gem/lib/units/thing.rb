class Thing
  
  include VectorUtilities
  include InitializerHooks
  include ItIsA
  
  # TODO Move these.
  #
  it_is Imageable
  it_is Moveable
  
  attr_writer :layer
  attr_reader :window, :shape
  
  # Every thing knows the window it is attached to.
  #
  def initialize window
    @window = window
    self.destroyed = false
    after_initialize
  end
  
  # Default layer is Layer::Players.
  #
  def self.layer layer
    InitializerHooks.register self do
      self.layer = layer
    end
  end
  def layer
    @layer || Layer::Players
  end
  
  class << self
    @@form_shape_class_mapping = { :circle => CP::Shape::Circle }
    def shape form
      form_shape_class_mapping = @@form_shape_class_mapping
      InitializerHooks.append self do
        shape_class = form_shape_class_mapping[form]
        raise "Shape #{form} does not exist." unless shape_class
        @shape = shape_class.new(CP::Body.new(self.mass, self.moment), self.radius, CP::Vec2.new(0.0, 0.0))
      end
    end
    def mass amount
      define_method :mass do
        amount || 1.0
      end
    end
    def moment amount
      define_method :moment do
        amount || 1.0
      end
    end
    def radius amount
      define_method :radius do
        amount || 10.0
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
  
  # Do something threaded.
  #
  # Default is: Instantly, in the next step.
  #
  def threaded time = 1, &code
    self.window.threaded time, &code
  end
  
  # Destroy this thing.
  #
  attr_writer :destroyed
  def destroyed?
    @destroyed
  end
  def destroy!
    return if self.destroyed?
    self.window.unregister self
    self.destroyed = true
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
  
  # Draws its image.
  #
  def draw
    self.image.draw_rot self.position.x, self.position.y, self.layer, self.drawing_rotation, 0.5, 0.5, *self.current_size
  end
  def current_size
    [1.0, 1.0] # default implementation - change this to [1.0, 2.0] if you want a "light" version ;)
  end
  
end