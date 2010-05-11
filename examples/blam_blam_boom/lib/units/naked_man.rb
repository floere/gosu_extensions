class NakedMan < Player
  
  sequenced_image 'naked_man.png', 32, 32, 5
  
  shape :poly, [CP::Vec2.new(-16,-9), CP::Vec2.new(-16,9), CP::Vec2.new(16,9), CP::Vec2.new(16,-9)]
  mass 100
  moment 100_000_000
  friction 0
  
  collision_type :player
  
end