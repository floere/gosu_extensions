class Thing
  
  include InitializerHooks
  
  attr_reader :window, :shape
  
  # Every thing knows the window it is attached to.
  #
  def initialize window
    @window = window
    after_initialize
  end
  
  class << self
    
    def image path, *args
      InitializerHooks.register self do
        @image = Gosu::Image.new self.window, path, *args
      end
    end
    @form_shape_class_mapping = {
      :circle => CP::Shape::Circle
    }
    def shape form
      InitializerHooks.append self do
        shape_class = @form_shape_class_mapping[form]
        if shape_class
          @shape = shape_class.new(CP::Body.new(@mass, @moment), @radius, CP::Vec2.new(0.0, 0.0))
        end
      end
    end
    def mass amount
      InitializerHooks.prepend self do
        @mass = amount || 1.0
      end
    end
    def moment amount
      InitializerHooks.prepend self do
        @moment = amount || 1.0
      end
    end
    def radius amount
      InitializerHooks.prepend self do
        @radius = amount || 1.0
      end
    end
    
    def collision_type type
      to_execute = lambda do
        @shape.collision_type = type
      end
      InitializerHooks.append self do
        # Ensure @shape exists
        #
        InitializerHooks.append self.class, &to_execute unless @shape
        to_execute.call
      end
    end
    
    def layer layer
      InitializerHooks.register self do
        @layer = layer
      end
    end
    
    def plays sound_path
      InitializerHooks.register self do
        @sound = Gosu::Sample.new self.window, sound_path
        @sound.play
      end
    end
    
    def draw_image
      
    end
    
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
  
  if sequenced_drawing
    def draw
      @image.draw_rot position.x, position.y, @layer, drawing_rotation
    end
  else
    def draw
      image = @image[Gosu::milliseconds / 100 % @image.size];
      image.draw_rot self.position.x, self.position.y, @layer, drawing_rotation
    end
  end
  
end