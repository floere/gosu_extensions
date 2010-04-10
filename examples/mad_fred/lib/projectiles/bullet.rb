#
#
class Bullet < Thing
  
  image 'bullet.png'
  
  layer Layer::Players
  
  it_is_a Shot
  
  shape :circle, 1.0
  mass 5
  moment 0.1
  friction 0.01
  velocity { 20 + rand }
  
  collision_type :player_projectile
  
  # plays 'bullet.wav', 'bullet.mp3'
  
  def move
    obey_gravity
    on_hitting_x { destroy!; return }
    on_hitting_y { destroy!; return }
  end
  
end