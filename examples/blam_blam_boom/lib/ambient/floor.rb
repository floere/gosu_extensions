class Floor < Thing
  
  image 'floor.png'
  
  # TODO :image
  shape :poly, [CP::Vec2.new(-20, -5),
                CP::Vec2.new(-20,  5),
                CP::Vec2.new( 20,  5),
                CP::Vec2.new( 20, -5)]
  mass 1_000_000
  moment 100_000_000
  friction 1.0
  rotation -Rotation::Quarter
  
  collision_type :ambient
  
end