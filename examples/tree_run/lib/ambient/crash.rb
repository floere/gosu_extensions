class Crash < Sprite
  
  layer Layer::UI
  
  image 'boom.png'
  
  it_is ShortLived
  lifetime 10
  
  rotation -Rotation::Quarter
  
end