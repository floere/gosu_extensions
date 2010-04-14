# Objects is an aggregator of things and sprites.
#
class Objects
  
  attr_reader :things, :sprites, :remove_things, :remove_sprites
  
  #
  #
  def initialize things, sprites
    @things, @sprites = things, sprites
    @remove_things, @remove_sprites = [], []
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
  
  def remove object
    Thing === object ? remove_things << object : remove_sprites << object
  end
  
  #
  #
  def remove_from environment
    @things.remove_from environment, remove_things # TODO Too much work being done
    @sprites.remove_from environment, remove_sprites
    remove_things.clear
    remove_sprites.clear
  end
  
end