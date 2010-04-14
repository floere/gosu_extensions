# Holds the things that are drawn.
#
class Sprites
  
  # TODO Remove delete.
  #
  delegate :each, :delete, :to => :@elements
  
  def initialize elements = []
    @elements = elements
  end
  
  def register element
    @elements << element
  end
  def registered? element
    @elements.include? element
  end
  
  def remove element
    @elements.delete element
  end
  
  def draw
    @elements.each &:draw
  end
  
  #
  #
  def remove_from environment, things
    things.each do |thing|
      remove thing # TODO Should the environment be the owner of the things? Probably, yes.
    end
  end
  
end