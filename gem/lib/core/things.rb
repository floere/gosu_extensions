# Holds the things that can collide, are moved and drawn.
#
class Things < Sprites
  
  delegate :each, :to => :@elements
  
  def initialize environment, elements = []
    @environment = environment
    super elements
  end
  
  def register element
    element.add_to @environment
    super element
  end
  
  def targeting # TODO
    @elements.select { |m| m.respond_to? :target }.each do |gun|
      gun.target *@elements.select { |m| m.kind_of? Enemy }
    end
  end
  
  #
  #
  def remove_marked
    @to_remove.each do |thing|
      @environment.remove thing
      @elements.delete thing # TODO Should the environment be the owner of the things? Probably, yes.
    end
    @to_remove.clear
  end
  
end