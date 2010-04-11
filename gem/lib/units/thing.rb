# Thing is a physical version of a sprite. Collides and has a mass and a moment.
#
class Thing < Sprite
  
  # TODO Move these up, perhaps?
  #
  it_is Moveable
  
  attr_reader :shape
  
  def mass
    0.1
  end
  def moment
    0.1
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
      InitializerHooks.append self do
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
  
end