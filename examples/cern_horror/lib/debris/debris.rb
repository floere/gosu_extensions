class Debris < Thing
  
  mass 120
  moment 0.1
  friction 100.0
  
  collision_type :debris
  
  random_rotation
  
  def move
    self.rotation += rand / 1000
    self.speed += window.gravity_vector_for(self) / 100
  end
  
  def current_size
    size = window.gravity_vector_for(self).length/30
    [size, size]
  end
  
end