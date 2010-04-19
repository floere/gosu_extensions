# This is attached to the player before appearing anywhere.
#
class Warp < Sprite
  
  layer Layer::UI
  
  it_is ShortLived
    lifetime { 10 + rand(10) }
  
  image 'warp.png'
  
  def current_size
    @multiplier ||= 4.0
    @multiplier *= 0.80
    [0.5*@multiplier, @multiplier]
  end
  
end