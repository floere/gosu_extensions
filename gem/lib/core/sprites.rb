# Holds the things that are drawn.
#
class Sprites
  
  def initialize elements = []
    @elements = elements
    @to_remove = []
  end
  
  def register element
    @elements << element
  end
  def registered? element
    @elements.include? element
  end
  
  def draw
    @elements.each &:draw
  end
  
  def remove object
    @to_remove << object
  end
  
  #
  #
  def remove_marked
    @to_remove.each do |object|
      @elements.delete object
    end
    @to_remove.clear
  end
  
end