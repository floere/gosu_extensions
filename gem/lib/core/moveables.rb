# Holds the moveables that are moved and drawn.
#
class Moveables
  
  delegate :each, :to => :@elements
  
  def initialize elements = []
    @elements = elements
  end
  
  def register moveable
    @elements << moveable
  end
  def registered? moveable
    @elements.include? moveable
  end
  def remove shape
    @elements.delete_if { |element| element.shape == shape }
  end
  
  def draw
    @elements.each &:draw
  end
  def move
    @elements.each &:move
  end
  def targeting
    @elements.select { |m| m.respond_to? :target }.each do |gun|
      gun.target *@elements.select { |m| m.kind_of? Enemy }
    end
  end
  
end