class Debris < Thing
  
  it_is_a Generator
    generates Smoke, :starting_at => 10, :every => 10
  
  # it_is ShortLived
  #   lifetime { 200 + rand(50) }
  
  image 'spaceship/debris.png'
  
  shape :circle, 5.0
  friction 50.0
  random_rotation
  # size 1..3
  
  layer Layer::Ambient
  
  collision_type :ambient
  
  def move
    obey_gravity
    on_hitting_y { destroy! }
    wrap_around_border_x
  end
  
end