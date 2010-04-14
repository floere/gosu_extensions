# Holds the things that can collide, are moved and drawn.
#
class Things < Sprites
  
  def move
    @elements.each &:move
  end
  def targeting # TODO
    @elements.select { |m| m.respond_to? :target }.each do |gun|
      gun.target *@elements.select { |m| m.kind_of? Enemy }
    end
  end
  
  #
  #
  def remove_from environment, things
    things.each do |thing|
      environment.remove thing.shape
      remove thing # TODO Should the environment be the owner of the things? Probably, yes.
    end
  end
  
end