# An enemy moves towards the players.
#
class Enemy < Thing
  
  include Lives
  
  lives 10
  sequenced_image 'enemy.png', 22, 22
  shape :circle, 11.0
  mass 1.0
  moment 1.0
  collision_type :enemy
  rotation -Math::PI/2
  layer Layer::Players
  
end