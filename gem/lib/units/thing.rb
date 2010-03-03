class Thing
  
  include InitializerHooks
  
  attr_writer :layer
  attr_reader :window, :shape
  
  # Every thing knows the window it is attached to.
  #
  def initialize window
    @window = window
    after_initialize
  end
  
  # Default layer is Layer::Players.
  #
  def layer
    @layer || Layer::Players
  end
  
  class << self
    
    def image path, *args
      InitializerHooks.register self do
        @image = Gosu::Image.new self.window, File.join(Resources.root, path), *args
      end
    end
    @@form_shape_class_mapping = {
      :circle => CP::Shape::Circle
    }
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
    
    def layer layer
      InitializerHooks.register self do
        self.layer = layer
      end
    end
    
    def plays sound_path
      InitializerHooks.register self do
        @sound = Gosu::Sample.new self.window, sound_path
        @sound.play
      end
    end
    
    def sequenced_image &block
      to_execute = block_given? ? block : lambda { Gosu::milliseconds / 100 }
      define_method :image do
        @image[to_execute[]]
      end
    end
    
  end
  
  def image
    @image
  end
  
  # Do something threaded.
  #
  def threaded time, &code
    self.window.threaded time, code
  end
  
  # Destroy this thing.
  #
  def destroy!
    self.window.unregister self
    true
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
    threaded units do
      self.instance_variable_set name, false
    end
    result
  end
  
  # Add this thing to a space.
  #
  # Note: Adds the body and the shape.
  #
  def add_to space
    space.add_body @shape.body
    space.add_shape @shape
  end
  
  # Include helpers. Multiple Modules (Traits) can be named.
  #
  # Examples:
  # * it_is_a Targetable, Accelerateable
  # * it_is Targeting::Closest
  #
  class << self
    def it_is *traits
      traits.each { |trait| include trait }
    end
    alias it_is_a it_is
  end
  
  # TODO
  #
  def draw
    self.image.draw_rot position.x, position.y, self.layer, self.drawing_rotation
  end
  
end