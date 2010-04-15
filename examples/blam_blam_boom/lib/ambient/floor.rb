class Floor < Thing
  
  image 'floor.png'
  
  # segment?
  shape :segment, CP::Vec2.new(-20, -5), CP::Vec2.new(20, -5), 10
  # shape :poly, [CP::Vec2.new(-20, -5),
  #               CP::Vec2.new(-20,  5),
  #               CP::Vec2.new( 20,  5),
  #               CP::Vec2.new( 20, -5)]
  mass 1_000_000
  moment 100_000_000
  friction 1.0
  
  collision_type :ambient
  
end