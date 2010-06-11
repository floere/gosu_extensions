class Sofa < Debris
  
  image 'debris/sofa.png'
  
  shape :poly, [CP::Vec2.new(-25,-12), CP::Vec2.new(-25,12), CP::Vec2.new(25,12), CP::Vec2.new(25,-12)]
  mass 120
  
  random_rotation
  
  def move
    self.rotation += rand / 1000
    self.speed += window.gravity_vector_for(self) / 200
  end
  
  def current_size
    size = window.gravity_vector_for(self).length/30
    [size, size]
  end
  
end