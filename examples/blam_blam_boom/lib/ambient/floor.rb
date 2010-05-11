class Floor < Thing
  
  image 'floor.png'
  
  shape :segment, CP::Vec2.new(-20, 0), CP::Vec2.new(20, 0), 8
  mass 1_000_000
  moment 100_000_000
  friction 100.0
  rotation 0
  
  collision_type :ambient
  
end