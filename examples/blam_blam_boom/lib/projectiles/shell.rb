#
#
class Shell < Thing
  
  image 'shell.png'
  
  layer Layer::Ambient
  
  it_is ShortLived
  lifetime { 50 + rand(50) }
  
  shape :circle, 1.0
  mass 1
  moment 0.1
  friction 0.01
  # velocity { 20 + rand }
  
  collision_type :weapon
  
  def move
    obey_gravity
    on_hitting_border { destroy! }
  end
  
end