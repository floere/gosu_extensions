#
class Smoke < Thing

  layer Layer::Ambient
  
  sequenced_image 'smoke.png', 10, 10, 1
  
  it_is ShortLived
  lifetime { 50 + rand(10) }
  
  shape :circle, 10.0
  friction 100.0       # TODO Remove these
  rotation { rand*-Math::PI/2 }
  collision_type :ambient
  
  # Smoke is reduced in size with each time it is "drawn".
  #
  def current_size
    @multiplier ||= 2.0
    @multiplier *= 0.97
    [@multiplier, @multiplier]
  end
  
end