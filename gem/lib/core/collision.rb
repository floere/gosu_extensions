class Collision
  
  # Default collision functions
  #
  None   = nil       # do not collide
  Simple = lambda { |arbiter| } # just collide
  # Kill   = lambda { kill! }
  # Damage = lambda { damage! }
  
  #
  #
  attr_reader :things, :this, :that, :definition
  
  # Things can collide.
  #
  def initialize things, this, that = this, &definition
    @things     = things
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
    lambda do |this_shape, _, arbiter|
      things.each do |thing|
        if thing.shape == this_shape
          thing.instance_eval &definition
          break
        end
      end
    end
  end
  
  #
  #
  def complex_package definition
    lambda do |this_shape, that_shape, arbiter|
      this_that = Array.new 2
      things.each do |thing|
        if thing.shape == this_shape
          this_that[0] = thing
          break if this_that.all?
        end
        if thing.shape == that_shape
          this_that[1] = thing
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