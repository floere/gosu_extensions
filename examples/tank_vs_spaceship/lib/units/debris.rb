class Debris < Thing
  
  it_is_a Generator
    generates Smoke, :starting_at => 10, :every => 10
  
  it_is ShortLived
    lifetime { 200 + rand(50) }
  
  image 'debris.png'
  
  shape :circle
  radius 5.0
  mass 0.1
  moment 0.1
  friction 50.0
  rotation -Math::PI/2
  
  layer Layer::Ambient
  
  collision_type :ambient
  
  def move
    obey_gravity
    on_hitting_y { destroy! }
    wrap_around_border_x
  end
  
end