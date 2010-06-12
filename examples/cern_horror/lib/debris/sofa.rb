class Sofa < Debris
  
  image 'debris/sofa.png'
  
  shape :poly, [CP::Vec2.new(-25,-12), CP::Vec2.new(-25,12), CP::Vec2.new(25,12), CP::Vec2.new(25,-12)]
  mass 200
  moment 100
  
end