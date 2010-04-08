#
class Smoke < Thing
  
  layer Layer::Ambient
  
  it_is ShortLived
  
  lifetime { 50 + rand(10) }
  sequenced_image 'smoke.png', 10, 10, 1
  shape :circle
  radius 1.0
  mass 0.1
  moment 0.1
  collision_type :ambient
  friction 0.0001
  rotation { rand(2)*Math::PI }
  
  # Smoke is reduced in size with each time it is "drawn".
  #
  def current_size
    @multiplier ||= 2.0
    @multiplier *= 0.97
    [@multiplier, @multiplier]
  end
  
  def move
    obey_gravity
    self.position.x -= window.current_speed
  end
  
end