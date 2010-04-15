#
class Smoke < Sprite
  
  sequenced_image 'smoke.png', 10, 10, 1
  
  it_is ShortLived
  lifetime { 50 + rand(10) }
  
  random_rotation
  
  # Smoke is reduced in size with each time it is "drawn".
  #
  def current_size
    @multiplier ||= 2.0
    @multiplier *= (95.0 + rand(5))/100
    [@multiplier, @multiplier]
  end
  
end