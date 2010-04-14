# Objects is an aggregator of things and sprites.
#
class Objects
  
  attr_reader :things, :sprites
  
  #
  #
  def initialize things, sprites
    @things, @sprites = things, sprites
  end
  
  # TODO Not used?
  #
  def registered? thing_or_sprite
    @things.registered?(thing_or_sprite) || @sprites.registered?(thing_or_sprite)
  end
  
  #
  #
  def register thing_or_sprite
    Thing === thing_or_sprite ? @things.register(thing_or_sprite) : @sprites.register(thing_or_sprite)
  end
  
  #
  #
  def move
    @things.move
  end
  
  #
  #
  def draw
    @things.draw
    @sprites.draw
  end
  
  #
  #
  def remove_marked
    @things.remove_marked
    @sprites.remove_marked
  end
  
end