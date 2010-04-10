#
#
class RemoveShapes
  
  attr_reader :shapes
  delegate :clear, :empty?, :to => :@shapes
  
  def initialize
    @shapes = []
  end
  
  #
  #
  def add shape
    shapes << shape
  end
  
  #
  #
  def remove_from environment, moveables
    # This iterator makes an assumption of one Shape per Star making it safe to remove
    # each Shape's Body as it comes up
    # If our Stars had multiple Shapes, as would be required if we were to meticulously
    # define their true boundaries, we couldn't do this as we would remove the Body
    # multiple times
    # We would probably solve this by creating a separate @remove_bodies array to remove the Bodies
    # of the Stars that were gathered by the Player
    #
    return if empty?
    shapes.each do |shape|
      environment.remove shape
      moveables.remove shape # TODO Should the environment be the owner of the moveables? Probably, yes.
    end
    clear
  end
  
end