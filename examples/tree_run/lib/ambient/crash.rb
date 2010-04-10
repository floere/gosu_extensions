class Crash < Thing
  
  it_is ShortLived
  lifetime 60
  
  image 'boom.png'
  
  shape :circle, 100
  mass 1000
  moment 0.01
  friction 1000
  rotation -Math::PI/2
  
  collision_type :ambient
  
end