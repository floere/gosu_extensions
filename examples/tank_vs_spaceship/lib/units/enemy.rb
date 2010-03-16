# An enemy moves towards the players.
#
class Enemy < Thing
  
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
  
end