#
#
class Bullet < Thing
  
  image 'bullet.png'
  
  layer Layer::Players
  
  it_is ShortLived
  lifetime { 30 + rand(10) }
  
  it_is Damaging
  damage { 10 + rand(20) }
  
  it_is_a Shot
  
  shape :circle, 1.0
  mass 50
  moment 0.1
  friction 0.01
  velocity { 20 + rand }
  
  collision_type :projectile
  
  # plays 'bullet.wav', 'bullet.mp3'
  
  def move
    # obey_gravity
    on_hitting_border { destroy! }
  end
  
end