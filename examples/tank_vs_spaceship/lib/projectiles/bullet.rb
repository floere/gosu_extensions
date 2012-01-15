#
#
class Bullet < Thing
  
  it_is ShortLived
  it_is_a Shot
  
  # it_is Damaging
  # damage 100
  
  lifetime { 100 + rand(50) }
  image 'bullet.png'
  shape :circle, 1.0
  mass 0.05
  moment 0.1
  collision_type :projectile
  friction 0
  velocity { 20 + rand }
  layer Layer::Players
  plays ['bullet.wav', 'bullet.mp3']
  
  def move
    obey_gravity
    on_hitting_y { destroy! }
    wrap_around_border_x # a helper method that makes the player wrap around the border
  end
  
end