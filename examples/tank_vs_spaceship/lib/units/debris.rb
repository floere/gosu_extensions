class Debris < Thing
  
  layer Layer::Players
  
  image 'spaceship/debris.png'
  
  it_is_a Generator; generates Smoke, :starting_at => 10, :every => 10
  
  it_is ShortLived; lifetime { 100 + rand(150) }
  
  shape :circle, 5.0
  random_rotation
  # size 1..3
  
  collision_type :projectile
  
  def move
    obey_gravity
    bounce_off_border_y
    wrap_around_border_x
  end
  
  # Debris is reduced in size with each time it is "drawn".
  #
  def current_size
    @multiplier ||= 1.0
    @multiplier *= 0.99
    [@multiplier, @multiplier]
  end
  
end