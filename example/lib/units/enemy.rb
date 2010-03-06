# An enemy moves towards the players.
#
class Enemy < Moveable
  
  include Lives
  it_is Targetable
  
  lives 10
  sequenced_image 'enemy.png', 22, 22
  shape :circle
  radius 11.0
  mass 1.0
  moment 1.0
  collision_type :enemy
  rotation -Math::PI/2
  layer Layer::Players
  
  # def initialize window
  #   super window
  #   
  #   # after_initialize
  # end
  
  # def draw
  #   image = @image[Gosu::milliseconds / 100 % @image.size];
  #   image.draw_rot self.position.x, self.position.y, ZOrder::Player, drawing_rotation
  # end
end