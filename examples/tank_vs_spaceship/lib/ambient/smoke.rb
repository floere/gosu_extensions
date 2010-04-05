#
class Smoke < Thing
  
  it_is ShortLived
  
  lifetime { 50 + rand(10) }
  sequenced_image 'smoke.png', 10, 10, 1
  shape :circle
  radius 1.0
  mass 0.1
  moment 0.1
  collision_type :ambient
  friction 0.0001
  layer Layer::Ambient
  
  # Smoke is reduced in size with each time it is "drawn".
  #
  def current_size
    @multiplier ||= 2.0
    @multiplier *= 0.97
    [1.0*@multiplier, 1.0*@multiplier]
  end
  
end