class Collision
  
  # Default collision functions
  #
  None   = nil       # do not collide
  Simple = lambda {} # just collide
  # Kill   = lambda { kill! }
  # Damage = lambda { damage! }
  
  #
  #
  attr_reader :window, :this, :that, :definition
  
  #
  #
  def initialize window, this, that = this, &definition
    @window     = window # TODO Remove.
    @this       = this
    @that       = that
    @definition = definition && package(definition)
  end
  
  # TODO Extend the definition to incorporate this
  #      method. Or at least #complex, #simple.
  #
  def package definition
    if definition.arity == 2
      complex_package definition
    else
      simple_package definition
    end
  end
  
  #
  #
  def simple_package definition
    lambda do |this_shape, _|
      window.moveables.each do |moveable|
        if moveable.shape == this_shape
          moveable.instance_eval &definition
          break
        end
      end
    end
  end
  
  #
  #
  def complex_package definition
    lambda do |this_shape, that_shape|
      this_that = Array.new 2
      window.moveables.each do |moveable|
        if moveable.shape == this_shape
          this_that[0] = moveable
          break if this_that.all?
        end
        if moveable.shape == that_shape
          this_that[1] = moveable
          break if this_that.all?
        end
      end
      definition.call *this_that
    end
  end
  
  # Install this collision on the given environment.
  #
  def install_on environment
    environment.add_collision_func this, that, &definition
  end
  
end