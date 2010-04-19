class OpenElevator < Thing
  
  image 'smoke.png'
  
  shape :poly, [CP::Vec2.new(-50, -300),
                CP::Vec2.new(-50,  300),
                CP::Vec2.new( 50,  300),
                CP::Vec2.new( 50, -300)]
  mass 1_000_000
  moment 100_000_000
  friction 0
  
  collision_type :elevator
  
end